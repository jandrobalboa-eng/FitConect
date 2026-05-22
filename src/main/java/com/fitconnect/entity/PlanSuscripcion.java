package com.fitconnect.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

/**
 * Planes de suscripción de FitConnect
 * Los entrenadores se suscriben a la plataforma con uno de estos planes.
 * Cada plan limita el número máximo de clientes que pueden gestionar.
 */
@Entity
@Table(name = "PlanSuscripcion")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class PlanSuscripcion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, unique = true)
    private TipoPlan tipo;

    @Column(nullable = false, precision = 8, scale = 2)
    private BigDecimal precioMensual;

    @Column(name = "max_clientes", nullable = false)
    private Integer maxClientes;

    @Column(nullable = false, length = 255)
    private String descripcion;

    public enum TipoPlan {
        BASICO, PRO, PREMIUM
    }
}
