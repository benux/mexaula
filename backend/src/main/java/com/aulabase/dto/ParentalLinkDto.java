package com.aulabase.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ParentalLinkDto {
    private Long id;
    private Long padreId;
    private Long alumnoId;
    private String alumnoNombre;
    private Instant creadoEn;
}

