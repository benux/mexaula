package com.aulabase.controller;

import com.aulabase.dto.ChildProgressDto;
import com.aulabase.dto.ParentalLinkDto;
import com.aulabase.dto.ParentalSettingsDto;
import com.aulabase.service.ParentalService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/parental")
@RequiredArgsConstructor
public class ParentalController {

    private final ParentalService parentalService;

    @GetMapping("/children")
    @PreAuthorize("hasRole('PADRE')")
    public ResponseEntity<List<ParentalLinkDto>> getChildren() {
        List<ParentalLinkDto> children = parentalService.getChildren();
        return ResponseEntity.ok(children);
    }

    @GetMapping("/children/{childId}/progress")
    @PreAuthorize("hasRole('PADRE')")
    public ResponseEntity<ChildProgressDto> getChildProgress(@PathVariable Long childId) {
        ChildProgressDto progress = parentalService.getChildProgress(childId);
        return ResponseEntity.ok(progress);
    }

    @GetMapping("/settings")
    @PreAuthorize("hasRole('PADRE')")
    public ResponseEntity<ParentalSettingsDto> getSettings() {
        ParentalSettingsDto settings = parentalService.getSettings();
        return ResponseEntity.ok(settings);
    }

    @PutMapping("/settings")
    @PreAuthorize("hasRole('PADRE')")
    public ResponseEntity<ParentalSettingsDto> updateSettings(@Valid @RequestBody ParentalSettingsDto settings) {
        ParentalSettingsDto updated = parentalService.updateSettings(settings);
        return ResponseEntity.ok(updated);
    }

    @PostMapping("/links")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ParentalLinkDto> createLink(@RequestBody Map<String, Long> request) {
        Long padreId = request.get("padreId");
        Long alumnoId = request.get("alumnoId");
        ParentalLinkDto link = parentalService.createLink(padreId, alumnoId);
        return ResponseEntity.ok(link);
    }

    @DeleteMapping("/links/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Map<String, String>> deleteLink(@PathVariable Long id) {
        parentalService.deleteLink(id);
        return ResponseEntity.ok(Map.of("message", "Vínculo eliminado exitosamente"));
    }
}

