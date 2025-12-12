package com.aulabase.dto;

import com.aulabase.model.EstadoTechPost;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TechPostDto {
    private Long id;
    private String titulo;
    private String resumen;
    private String contenidoMarkdown;
    private String slug;
    private String categoria;
    private List<String> etiquetas;
    private EstadoTechPost estado;
    private Long autorId;
    private String autorNombre;
    private Instant creadoEn;
    private Instant actualizadoEn;
}

