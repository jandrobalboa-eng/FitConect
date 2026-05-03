package com.fitconnect.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class MetricaRequest {

    @NotNull(message = "La fecha es obligatoria")
    private LocalDate fecha;

    private BigDecimal peso;
    private BigDecimal medidaCintura;
    private BigDecimal medidaCadera;
    private String notas;
}