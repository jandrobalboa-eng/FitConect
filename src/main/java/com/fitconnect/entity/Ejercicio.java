package com.fitconnect.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "Ejercicio")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Ejercicio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 255)
    private String nombre;

    @Column(columnDefinition = "TEXT")
    private String descripcion;

    @Column(name = "gif_url", length = 500)
    private String gifUrl;

    @Column(name = "musculo_objetivo", length = 100)
    private String musculoObjetivo;

    @Column(name = "es_predefinido")
    private Boolean esPredefinido = true;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "creado_por")
    private User creadoPor;
}
