package com.aulabase.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CertificateDto {
    private Long id;
    private Long alumnoId;
    private String alumnoNombre;
    private Long cursoId;
    private String cursoTitulo;
    private String codigoVerificacion;
    private Instant fechaEmision;
}

