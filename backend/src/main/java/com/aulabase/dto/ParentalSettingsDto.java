package com.aulabase.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ParentalSettingsDto {
    private Long id;
    private Long padreId;
    private String nivelMaximoContenido;
    private Integer tiempoMaximoDiarioMin;
    private Instant creadoEn;
    private Instant actualizadoEn;
}

