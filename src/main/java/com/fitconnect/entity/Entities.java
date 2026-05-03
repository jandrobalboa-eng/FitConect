package com.fitconnect.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

// ============================================================
// METRICA CORPORAL
// ============================================================
@Entity
@Table(name = "MetricaCorporal")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
class MetricaCorporal {

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

// ============================================================
// SUSCRIPCION
// ============================================================
@Entity
@Table(name = "Suscripcion")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
class Suscripcion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cliente_id", nullable = false)
    private User cliente;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "entrenador_id", nullable = false)
    private User entrenador;

    @Column(name = "fecha_inicio", nullable = false)
    private LocalDate fechaInicio;

    @Column(name = "fecha_fin", nullable = false)
    private LocalDate fechaFin;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Estado estado;

    @Enumerated(EnumType.STRING)
    @Column(name = "tipo_pago", nullable = false)
    private TipoPago tipoPago;

    public enum Estado { Activa, Cancelada, Expirada }
    public enum TipoPago { Mensual, Anual }
}

// ============================================================
// PLAN DE ALIMENTACION
// ============================================================
@Entity
@Table(name = "PlanAlimentacion")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
class PlanAlimentacion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "entrenador_id", nullable = false)
    private User entrenador;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cliente_id", nullable = false)
    private User cliente;

    @Column(nullable = false, length = 255)
    private String nombre;

    @Column(columnDefinition = "TEXT")
    private String descripcion;

    @Column(columnDefinition = "JSON")
    private String contenido;

    @Column(name = "fecha_asignacion", nullable = false)
    private LocalDate fechaAsignacion;
}

// ============================================================
// CONVERSACION
// ============================================================
@Entity
@Table(name = "Conversacion",
       uniqueConstraints = @UniqueConstraint(columnNames = {"cliente_id", "entrenador_id"}))
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
class Conversacion {

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

// ============================================================
// MENSAJE
// ============================================================
@Entity
@Table(name = "Mensaje")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
class Mensaje {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "conversacion_id", nullable = false)
    private Conversacion conversacion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "remitente_id", nullable = false)
    private User remitente;

    @Column(columnDefinition = "TEXT")
    private String contenido;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TipoMensaje tipo;

    @Column(name = "url_archivo", length = 500)
    private String urlArchivo;

    @Column(name = "fecha_envio")
    private LocalDateTime fechaEnvio;

    public enum TipoMensaje { texto, video }

    @PrePersist
    public void prePersist() {
        if (fechaEnvio == null) fechaEnvio = LocalDateTime.now();
    }
}
