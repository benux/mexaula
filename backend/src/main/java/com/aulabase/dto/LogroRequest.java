package com.aulabase.dto;

import com.aulabase.model.TipoLogro;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LogroRequest {

    @NotBlank(message = "El título es obligatorio")
    private String titulo;

    @NotBlank(message = "La descripción es obligatoria")
    private String descripcion;

    private String iconoUrl;

    @NotNull(message = "El tipo es obligatorio")
    private TipoLogro tipo;

    @NotBlank(message = "El criterio código es obligatorio")
    private String criterioCodigo;

    @NotNull(message = "Los puntos son obligatorios")
    @Min(value = 0, message = "Los puntos deben ser mayor o igual a 0")
    private Integer puntos;

    private Boolean activo = true;
}

