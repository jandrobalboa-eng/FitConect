package com.fitconnect.dto.response;

import com.fitconnect.entity.Suscripcion;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@Getter
@Builder
public class SuscripcionResponse {

    private Integer id;
    private String clienteNombre;
    private String clienteEmail;
    private String entrenadorNombre;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private long mesesContratados;
    private String estado;

    public static SuscripcionResponse from(Suscripcion s) {
        return SuscripcionResponse.builder()
                .id(s.getId())
                .clienteNombre(s.getCliente().getNombre())
                .clienteEmail(s.getCliente().getEmail())
                .entrenadorNombre(s.getEntrenador().getNombre())
                .fechaInicio(s.getFechaInicio())
                .fechaFin(s.getFechaFin())
                .mesesContratados(ChronoUnit.MONTHS.between(s.getFechaInicio(), s.getFechaFin()))
                .estado(s.getEstado().name())
                .build();
    }
}