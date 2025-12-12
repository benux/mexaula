package com.aulabase.dto;

import com.aulabase.model.TipoLogro;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LogroDto {
    private Long id;
    private String titulo;
    private String descripcion;
    private String iconoUrl;
    private TipoLogro tipo;
    private String criterioCodigo;
    private Integer puntos;
    private Boolean activo;
    private Instant creadoEn;
    private Instant actualizadoEn;
}

