package com.aulabase.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.Instant;

@Entity
@Table(name = "logros_usuarios",
       uniqueConstraints = @UniqueConstraint(columnNames = {"logro_id", "alumno_id"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LogroUsuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "logro_id", nullable = false)
    private Logro logro;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "alumno_id", nullable = false)
    private Usuario alumno;

    @CreationTimestamp
    @Column(name = "fecha_obtenido", nullable = false, updatable = false)
    private Instant fechaObtenido;

    @Column(name = "compartido_veces", nullable = false)
    private Integer compartidoVeces = 0;
}

