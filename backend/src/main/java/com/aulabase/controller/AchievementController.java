package com.aulabase.controller;

import com.aulabase.dto.LogroDto;
import com.aulabase.dto.LogroRequest;
import com.aulabase.dto.LogroUsuarioDto;
import com.aulabase.model.Usuario;
import com.aulabase.repository.UsuarioRepository;
import com.aulabase.service.AchievementService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/achievements")
@RequiredArgsConstructor
public class AchievementController {

    private final AchievementService achievementService;
    private final UsuarioRepository usuarioRepository;

    // ========== Endpoints para ADMIN ==========

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<LogroDto>> getAllLogros() {
        return ResponseEntity.ok(achievementService.getAllLogros());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<LogroDto> getLogroById(@PathVariable Long id) {
        return ResponseEntity.ok(achievementService.getLogroById(id));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<LogroDto> createLogro(@Valid @RequestBody LogroRequest request) {
        LogroDto created = achievementService.createLogro(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<LogroDto> updateLogro(
            @PathVariable Long id,
            @Valid @RequestBody LogroRequest request) {
        return ResponseEntity.ok(achievementService.updateLogro(id, request));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteLogro(@PathVariable Long id) {
        achievementService.deleteLogro(id);
        return ResponseEntity.noContent().build();
    }

    // ========== Endpoints para ALUMNOS ==========

    @GetMapping("/active")
    public ResponseEntity<List<LogroDto>> getActiveLogros() {
        return ResponseEntity.ok(achievementService.getActiveLogros());
    }

    @GetMapping("/my")
    @PreAuthorize("hasRole('ALUMNO')")
    public ResponseEntity<List<LogroUsuarioDto>> getMyLogros(Authentication authentication) {
        String email = authentication.getName();
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        return ResponseEntity.ok(achievementService.getAlumnoLogros(usuario.getId()));
    }

    @PostMapping("/{userAchievementId}/shared")
    @PreAuthorize("hasRole('ALUMNO')")
    public ResponseEntity<Void> incrementShareCount(@PathVariable Long userAchievementId) {
        achievementService.incrementShareCount(userAchievementId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/my/stats")
    @PreAuthorize("hasRole('ALUMNO')")
    public ResponseEntity<AchievementStats> getMyStats(Authentication authentication) {
        String email = authentication.getName();
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        long totalLogros = achievementService.countAlumnoLogros(usuario.getId());
        int totalPuntos = achievementService.getTotalPuntosAlumno(usuario.getId());

        return ResponseEntity.ok(new AchievementStats(totalLogros, totalPuntos));
    }

    // Inner class for stats response
    public record AchievementStats(long totalLogros, int totalPuntos) {}
}
