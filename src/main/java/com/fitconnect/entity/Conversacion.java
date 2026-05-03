package com.fitconnect.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "Conversacion",
       uniqueConstraints = @UniqueConstraint(columnNames = {"cliente_id", "entrenador_id"}))
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Conversacion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cliente_id", nullable = false)
    private User cliente;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "entrenador_id", nullable = false)
    private User entrenador;
}