package com.aulabase.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProgressUpdateRequest {

    @NotNull(message = "El progreso es requerido")
    @Min(value = 0, message = "El progreso mínimo es 0")
    @Max(value = 100, message = "El progreso máximo es 100")
    private Double progresoPorcentaje;
}

