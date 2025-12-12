package com.aulabase.model;

import com.aulabase.util.StringListConverter;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.Instant;
import java.util.List;

@Entity
@Table(name = "tech_posts")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TechPost {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String titulo;

    @Column(nullable = false, length = 500)
    private String resumen;

    @Column(name = "contenido_markdown", nullable = false, columnDefinition = "TEXT")
    private String contenidoMarkdown;

    @Column(nullable = false, unique = true, length = 200)
    private String slug;

    @Column(length = 100)
    private String categoria;

    @Column(columnDefinition = "TEXT")
    @Convert(converter = StringListConverter.class)
    private List<String> etiquetas;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private EstadoTechPost estado;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "autor_id", nullable = false)
    private Usuario autor;

    @CreationTimestamp
    @Column(name = "creado_en", nullable = false, updatable = false)
    private Instant creadoEn;

    @UpdateTimestamp
    @Column(name = "actualizado_en", nullable = false)
    private Instant actualizadoEn;
}

