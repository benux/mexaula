package com.aulabase.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CourseRequest {

    @NotBlank(message = "El título es requerido")
    private String titulo;

    private String descripcion;

    @NotBlank(message = "El nivel es requerido")
    private String nivel; // BASICO, INTERMEDIO, AVANZADO

    @NotNull(message = "El campo publicado es requerido")
    private Boolean publicado;

    private Long maestroId; // Solo para admins creando curso
}

