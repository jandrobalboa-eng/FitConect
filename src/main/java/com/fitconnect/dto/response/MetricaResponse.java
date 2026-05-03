package com.fitconnect.dto.response;

import com.fitconnect.entity.MetricaCorporal;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class MetricaResponse {

    private Integer id;
    private LocalDate fecha;
    private BigDecimal peso;
    private BigDecimal medidaCintura;
    private BigDecimal medidaCadera;
    private String notas;

    public static MetricaResponse from(MetricaCorporal m) {
        return MetricaResponse.builder()
                .id(m.getId())
                .fecha(m.getFecha())
                .peso(m.getPeso())
                .medidaCintura(m.getMedidaCintura())
                .medidaCadera(m.getMedidaCadera())
                .notas(m.getNotas())
                .build();
    }
}