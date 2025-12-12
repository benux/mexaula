package com.aulabase.service;

import com.aulabase.dto.ChangePasswordRequest;
import com.aulabase.dto.UserDto;
import com.aulabase.exception.BadRequestException;
import com.aulabase.exception.ResourceNotFoundException;
import com.aulabase.model.Rol;
import com.aulabase.model.Usuario;
import com.aulabase.repository.RolRepository;
import com.aulabase.repository.UsuarioRepository;
import com.aulabase.util.DtoMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UsuarioRepository usuarioRepository;
    private final RolRepository rolRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthService authService;

    public List<UserDto> getAllUsers() {
        return usuarioRepository.findAll().stream()
                .map(DtoMapper::toUserDto)
                .collect(Collectors.toList());
    }

    public UserDto getUserById(Long id) {
        Usuario usuario = usuarioRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado con id: " + id));
        return DtoMapper.toUserDto(usuario);
    }

    @Transactional
    public UserDto createUser(UserDto userDto, String password, List<String> roles) {
        if (usuarioRepository.existsByEmail(userDto.getEmail())) {
            throw new BadRequestException("El email ya está registrado");
        }

        Usuario usuario = new Usuario();
        usuario.setNombre(userDto.getNombre());
        usuario.setApellido(userDto.getApellido());
        usuario.setEmail(userDto.getEmail());
        usuario.setPasswordHash(passwordEncoder.encode(password));
        usuario.setActivo(userDto.isActivo());

        Set<Rol> rolesSet = new HashSet<>();
        for (String rolNombre : roles) {
            Rol rol = rolRepository.findByNombre(rolNombre)
                    .orElseThrow(() -> new BadRequestException("Rol no encontrado: " + rolNombre));
            rolesSet.add(rol);
        }
        usuario.setRoles(rolesSet);

        usuario = usuarioRepository.save(usuario);
        return DtoMapper.toUserDto(usuario);
    }

    @Transactional
    public UserDto updateUser(Long id, UserDto userDto, List<String> roles) {
        Usuario usuario = usuarioRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado con id: " + id));

        usuario.setNombre(userDto.getNombre());
        usuario.setApellido(userDto.getApellido());
        usuario.setActivo(userDto.isActivo());

        if (!usuario.getEmail().equals(userDto.getEmail())) {
            if (usuarioRepository.existsByEmail(userDto.getEmail())) {
                throw new BadRequestException("El email ya está registrado");
            }
            usuario.setEmail(userDto.getEmail());
        }

        if (roles != null && !roles.isEmpty()) {
            Set<Rol> rolesSet = new HashSet<>();
            for (String rolNombre : roles) {
                Rol rol = rolRepository.findByNombre(rolNombre)
                        .orElseThrow(() -> new BadRequestException("Rol no encontrado: " + rolNombre));
                rolesSet.add(rol);
            }
            usuario.setRoles(rolesSet);
        }

        usuario = usuarioRepository.save(usuario);
        return DtoMapper.toUserDto(usuario);
    }

    @Transactional
    public void toggleUserStatus(Long id) {
        Usuario usuario = usuarioRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado con id: " + id));
        usuario.setActivo(!usuario.isActivo());
        usuarioRepository.save(usuario);
    }

    @Transactional
    public UserDto updateProfile(UserDto userDto) {
        Usuario usuario = authService.getCurrentUserEntity();

        usuario.setNombre(userDto.getNombre());
        usuario.setApellido(userDto.getApellido());

        if (!usuario.getEmail().equals(userDto.getEmail())) {
            if (usuarioRepository.existsByEmail(userDto.getEmail())) {
                throw new BadRequestException("El email ya está registrado");
            }
            usuario.setEmail(userDto.getEmail());
        }

        usuario = usuarioRepository.save(usuario);
        return DtoMapper.toUserDto(usuario);
    }

    @Transactional
    public void changePassword(ChangePasswordRequest request) {
        Usuario usuario = authService.getCurrentUserEntity();

        if (!passwordEncoder.matches(request.getCurrentPassword(), usuario.getPasswordHash())) {
            throw new BadRequestException("La contraseña actual es incorrecta");
        }

        usuario.setPasswordHash(passwordEncoder.encode(request.getNewPassword()));
        usuarioRepository.save(usuario);
    }

    public List<String> getAllRoles() {
        return rolRepository.findAll().stream()
                .map(Rol::getNombre)
                .collect(Collectors.toList());
    }
}

