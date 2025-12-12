package com.aulabase.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CourseDto {
    private Long id;
    private String titulo;
    private String descripcion;
    private String nivel;
    private boolean publicado;
    private Long maestroId;
    private String maestroNombre;
    private Instant creadoEn;
    private Instant actualizadoEn;
}

