package com.aulabase.dto;

import com.aulabase.model.EstadoTechPost;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TechPostRequest {

    @NotBlank(message = "El título es obligatorio")
    private String titulo;

    @NotBlank(message = "El resumen es obligatorio")
    private String resumen;

    @NotBlank(message = "El contenido es obligatorio")
    private String contenidoMarkdown;

    @NotBlank(message = "El slug es obligatorio")
    private String slug;

    private String categoria;

    private List<String> etiquetas;

    @NotNull(message = "El estado es obligatorio")
    private EstadoTechPost estado;
}

