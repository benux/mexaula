package com.aulabase.controller;

import com.aulabase.dto.CertificateDto;
import com.aulabase.dto.CertificateRequest;
import com.aulabase.service.CertificateService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/certificates")
@RequiredArgsConstructor
public class CertificateController {

    private final CertificateService certificateService;

    @GetMapping("/my")
    @PreAuthorize("hasRole('ALUMNO')")
    public ResponseEntity<List<CertificateDto>> getMyCertificates() {
        List<CertificateDto> certificates = certificateService.getMyCertificates();
        return ResponseEntity.ok(certificates);
    }

    @PostMapping
    @PreAuthorize("hasRole('ALUMNO')")
    public ResponseEntity<CertificateDto> generateCertificate(@Valid @RequestBody CertificateRequest request) {
        CertificateDto certificate = certificateService.generateCertificate(request);
        return ResponseEntity.ok(certificate);
    }

    @GetMapping("/verify/{codigo}")
    public ResponseEntity<CertificateDto> verifyCertificate(@PathVariable String codigo) {
        CertificateDto certificate = certificateService.verifyCertificate(codigo);
        return ResponseEntity.ok(certificate);
    }
}

