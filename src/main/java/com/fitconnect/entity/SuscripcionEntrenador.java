package com.fitconnect.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;

/**
 * Suscripción del ENTRENADOR a la plataforma FitConnect.
 * Distinto de Suscripcion (que es cliente -> entrenador).
 * Esta es entrenador -> FitConnect (la empresa).
 */
@Entity
@Table(name = "SuscripcionEntrenador")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class SuscripcionEntrenador {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "entrenador_id", nullable = false, unique = true)
    private User entrenador;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PlanSuscripcion.TipoPlan plan;

    @Column(name = "fecha_inicio", nullable = false)
    private LocalDate fechaInicio;

    @Column(name = "fecha_fin")
    private LocalDate fechaFin;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Estado estado;

    public enum Estado { ACTIVA, CANCELADA, EXPIRADA }
}
