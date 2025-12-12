package com.aulabase.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EnrollmentDto {
    private Long id;
    private Long cursoId;
    private String cursoTitulo;
    private Long alumnoId;
    private String alumnoNombre;
    private Double progresoPorcentaje;
    private boolean completado;
    private Instant inscritoEn;
    private Instant actualizadoEn;
}

