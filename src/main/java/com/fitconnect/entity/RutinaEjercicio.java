package com.fitconnect.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "RutinaEjercicio")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class RutinaEjercicio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "rutina_id", nullable = false)
    private Rutina rutina;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ejercicio_id", nullable = false)
    private Ejercicio ejercicio;

    private Integer series;

    @Column(length = 50)
    private String repeticiones;

    @Column(length = 20)
    private String descanso;

    @Enumerated(EnumType.STRING)
    @Column(name = "dia_semana")
    private DiaSemana diaSemana;

    public enum DiaSemana {
        Lunes, Martes, Miércoles, Jueves, Viernes, Sábado, Domingo
    }
}
