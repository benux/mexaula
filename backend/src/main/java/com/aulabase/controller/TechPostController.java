package com.aulabase.controller;

import com.aulabase.dto.TechPostDto;
import com.aulabase.dto.TechPostRequest;
import com.aulabase.model.Usuario;
import com.aulabase.repository.UsuarioRepository;
import com.aulabase.service.TechPostService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/tech-posts")
@RequiredArgsConstructor
public class TechPostController {

    private final TechPostService techPostService;
    private final UsuarioRepository usuarioRepository;

    // ========== Endpoints públicos/autenticados (lectura) ==========

    @GetMapping
    public ResponseEntity<List<TechPostDto>> getPublishedTechPosts() {
        return ResponseEntity.ok(techPostService.getPublishedTechPosts());
    }

    @GetMapping("/{id}")
    public ResponseEntity<TechPostDto> getPublishedTechPostById(@PathVariable Long id) {
        // This will return the tech post by ID, and the service should ensure it's published
        return ResponseEntity.ok(techPostService.getTechPostById(id));
    }

    @GetMapping("/slug/{slug}")
    public ResponseEntity<TechPostDto> getTechPostBySlug(@PathVariable String slug) {
        return ResponseEntity.ok(techPostService.getTechPostBySlug(slug));
    }

    @GetMapping("/category/{categoria}")
    public ResponseEntity<List<TechPostDto>> getTechPostsByCategory(@PathVariable String categoria) {
        return ResponseEntity.ok(techPostService.getTechPostsByCategory(categoria));
    }

    // ========== Endpoints para ADMIN/MAESTRO ==========

    @GetMapping("/admin")
    @PreAuthorize("hasAnyRole('ADMIN', 'MAESTRO')")
    public ResponseEntity<List<TechPostDto>> getAllTechPosts() {
        return ResponseEntity.ok(techPostService.getAllTechPosts());
    }

    @GetMapping("/admin/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MAESTRO')")
    public ResponseEntity<TechPostDto> getTechPostById(@PathVariable Long id) {
        return ResponseEntity.ok(techPostService.getTechPostById(id));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'MAESTRO')")
    public ResponseEntity<TechPostDto> createTechPost(
            @Valid @RequestBody TechPostRequest request,
            Authentication authentication) {
        String email = authentication.getName();
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        TechPostDto created = techPostService.createTechPost(request, usuario.getId());
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MAESTRO')")
    public ResponseEntity<TechPostDto> updateTechPost(
            @PathVariable Long id,
            @Valid @RequestBody TechPostRequest request) {
        return ResponseEntity.ok(techPostService.updateTechPost(id, request));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MAESTRO')")
    public ResponseEntity<Void> deleteTechPost(@PathVariable Long id) {
        techPostService.deleteTechPost(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/my-posts")
    @PreAuthorize("hasAnyRole('ADMIN', 'MAESTRO')")
    public ResponseEntity<List<TechPostDto>> getMyTechPosts(Authentication authentication) {
        String email = authentication.getName();
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        return ResponseEntity.ok(techPostService.getTechPostsByAutor(usuario.getId()));
    }
}

