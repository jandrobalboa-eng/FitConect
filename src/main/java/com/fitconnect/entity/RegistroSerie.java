package com.fitconnect.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;

@Entity
@Table(name = "RegistroSerie")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class RegistroSerie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sesion_id", nullable = false)
    private SesionEntrenamiento sesion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "rutina_ejercicio_id", nullable = false)
    private RutinaEjercicio rutinaEjercicio;

    @Column(name = "numero_serie", nullable = false)
    private Integer numeroSerie;

    @Column(name = "peso_kg", precision = 6, scale = 2)
    private BigDecimal pesoKg;

    @Column(name = "reps_realizadas")
    private Integer repsRealizadas;

    private Integer rir;
}