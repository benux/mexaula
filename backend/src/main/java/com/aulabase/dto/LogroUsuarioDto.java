package com.aulabase.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LogroUsuarioDto {
    private Long id;
    private LogroDto logro;
    private Long alumnoId;
    private String alumnoNombre;
    private Instant fechaObtenido;
    private Integer compartidoVeces;
}

