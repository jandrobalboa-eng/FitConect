package com.fitconnect.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "SesionEntrenamiento")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class SesionEntrenamiento {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cliente_id", nullable = false)
    private User cliente;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "rutina_id", nullable = false)
    private Rutina rutina;

    @Column(nullable = false)
    private LocalDate fecha;

    @OneToMany(mappedBy = "sesion", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<RegistroSerie> registros;
}