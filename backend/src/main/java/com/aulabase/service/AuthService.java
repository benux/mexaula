package com.aulabase.service;

import com.aulabase.dto.LoginRequest;
import com.aulabase.dto.LoginResponse;
import com.aulabase.dto.RegisterRequest;
import com.aulabase.dto.UserDto;
import com.aulabase.exception.BadRequestException;
import com.aulabase.model.Rol;
import com.aulabase.model.Usuario;
import com.aulabase.repository.RolRepository;
import com.aulabase.repository.UsuarioRepository;
import com.aulabase.security.JwtService;
import com.aulabase.util.DtoMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.Set;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {

    private final UsuarioRepository usuarioRepository;
    private final RolRepository rolRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    @Transactional
    public UserDto register(RegisterRequest request) {
        if (usuarioRepository.existsByEmail(request.getEmail())) {
            throw new BadRequestException("El email ya está registrado");
        }

        // Determinar rol (solo ALUMNO o PADRE permitidos en registro público)
        final String rolNombre;
        if (request.getRolDeseado() != null) {
            String rolDeseado = request.getRolDeseado().toUpperCase();
            if (rolDeseado.equals("PADRE")) {
                rolNombre = "PADRE";
            } else if (rolDeseado.equals("ALUMNO")) {
                rolNombre = "ALUMNO";
            } else {
                throw new BadRequestException("Solo se permiten roles ALUMNO o PADRE en el registro");
            }
        } else {
            rolNombre = "ALUMNO"; // Por defecto
        }

        final String errorMsg = "Rol no encontrado: " + rolNombre;
        Rol rol = rolRepository.findByNombre(rolNombre)
                .orElseThrow(() -> new BadRequestException(errorMsg));

        Usuario usuario = new Usuario();
        usuario.setNombre(request.getNombre());
        usuario.setApellido(request.getApellido());
        usuario.setEmail(request.getEmail());
        usuario.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        usuario.setActivo(true);

        Set<Rol> roles = new HashSet<>();
        roles.add(rol);
        usuario.setRoles(roles);

        usuario = usuarioRepository.save(usuario);
        return DtoMapper.toUserDto(usuario);
    }

    public LoginResponse login(LoginRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail(),
                        request.getPassword()
                )
        );

        Usuario usuario = usuarioRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new BadRequestException("Usuario no encontrado"));

        if (!usuario.isActivo()) {
            throw new BadRequestException("Usuario inactivo");
        }

        UserDetails userDetails = org.springframework.security.core.userdetails.User.builder()
                .username(usuario.getEmail())
                .password(usuario.getPasswordHash())
                .authorities(usuario.getRoles().stream()
                        .map(rol -> "ROLE_" + rol.getNombre())
                        .toArray(String[]::new))
                .build();

        String token = jwtService.generateToken(userDetails);
        UserDto userDto = DtoMapper.toUserDto(usuario);

        return new LoginResponse(token, userDto);
    }

    public UserDto getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email = authentication.getName();

        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new BadRequestException("Usuario no encontrado"));

        return DtoMapper.toUserDto(usuario);
    }

    public Usuario getCurrentUserEntity() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email = authentication.getName();

        return usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new BadRequestException("Usuario no encontrado"));
    }
}

