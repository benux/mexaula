package com.aulabase.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.Instant;

@Entity
@Table(name = "configuracion_parental")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ConfiguracionParental {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "padre_id", nullable = false, unique = true)
    private Usuario padre;

    @Column(name = "nivel_maximo_contenido")
    private String nivelMaximoContenido;

    @Column(name = "tiempo_maximo_diario_min")
    private Integer tiempoMaximoDiarioMin;

    @CreationTimestamp
    @Column(name = "creado_en", nullable = false, updatable = false)
    private Instant creadoEn;

    @UpdateTimestamp
    @Column(name = "actualizado_en", nullable = false)
    private Instant actualizadoEn;
}

