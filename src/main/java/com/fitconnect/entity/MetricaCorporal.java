package com.fitconnect.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "MetricaCorporal")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class MetricaCorporal {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cliente_id", nullable = false)
    private User cliente;

    @Column(nullable = false)
    private LocalDate fecha;

    @Column(precision = 5, scale = 2)
    private BigDecimal peso;

    @Column(name = "medida_cintura", precision = 5, scale = 2)
    private BigDecimal medidaCintura;

    @Column(name = "medida_cadera", precision = 5, scale = 2)
    private BigDecimal medidaCadera;

    @Column(columnDefinition = "TEXT")
    private String notas;
}