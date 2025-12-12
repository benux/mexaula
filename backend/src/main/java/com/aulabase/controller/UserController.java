package com.aulabase.controller;

import com.aulabase.dto.ChangePasswordRequest;
import com.aulabase.dto.UserDto;
import com.aulabase.service.AuthService;
import com.aulabase.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final AuthService authService;

    @GetMapping("/me")
    public ResponseEntity<UserDto> getMyProfile() {
        UserDto user = authService.getCurrentUser();
        return ResponseEntity.ok(user);
    }

    @PutMapping("/me")
    public ResponseEntity<UserDto> updateMyProfile(@Valid @RequestBody UserDto userDto) {
        UserDto updated = userService.updateProfile(userDto);
        return ResponseEntity.ok(updated);
    }

    @PostMapping("/change-password")
    public ResponseEntity<Map<String, String>> changePassword(@Valid @RequestBody ChangePasswordRequest request) {
        userService.changePassword(request);
        return ResponseEntity.ok(Map.of("message", "Contraseña cambiada exitosamente"));
    }

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<UserDto>> getAllUsers() {
        List<UserDto> users = userService.getAllUsers();
        return ResponseEntity.ok(users);
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<UserDto> getUserById(@PathVariable Long id) {
        UserDto user = userService.getUserById(id);
        return ResponseEntity.ok(user);
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<UserDto> createUser(@Valid @RequestBody Map<String, Object> request) {
        UserDto userDto = new UserDto();
        userDto.setNombre((String) request.get("nombre"));
        userDto.setApellido((String) request.get("apellido"));
        userDto.setEmail((String) request.get("email"));
        userDto.setActivo((Boolean) request.getOrDefault("activo", true));

        String password = (String) request.get("password");
        @SuppressWarnings("unchecked")
        List<String> roles = (List<String>) request.get("roles");

        UserDto created = userService.createUser(userDto, password, roles);
        return ResponseEntity.ok(created);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<UserDto> updateUser(
            @PathVariable Long id,
            @Valid @RequestBody Map<String, Object> request
    ) {
        UserDto userDto = new UserDto();
        userDto.setNombre((String) request.get("nombre"));
        userDto.setApellido((String) request.get("apellido"));
        userDto.setEmail((String) request.get("email"));
        userDto.setActivo((Boolean) request.get("activo"));

        @SuppressWarnings("unchecked")
        List<String> roles = (List<String>) request.get("roles");

        UserDto updated = userService.updateUser(id, userDto, roles);
        return ResponseEntity.ok(updated);
    }

    @PatchMapping("/{id}/status")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Map<String, String>> toggleUserStatus(@PathVariable Long id) {
        userService.toggleUserStatus(id);
        return ResponseEntity.ok(Map.of("message", "Estado del usuario actualizado"));
    }

    @GetMapping("/roles")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<String>> getAllRoles() {
        List<String> roles = userService.getAllRoles();
        return ResponseEntity.ok(roles);
    }
}

