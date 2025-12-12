package com.aulabase.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChildCourseProgressDto {
    private Long cursoId;
    private String titulo;
    private Double progresoPorcentaje;
    private boolean completado;
}

