package com.fitconnect.dto.response;

import com.fitconnect.entity.RegistroSerie;
import com.fitconnect.entity.SesionEntrenamiento;
import lombok.Builder;
import lombok.Getter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

@Getter
@Builder
public class SesionResponse {

    private Integer id;
    private Integer rutinaId;
    private String rutinaNombre;
    private LocalDate fecha;
    private List<RegistroSerieResponse> registros;

    @Getter
    @Builder
    public static class RegistroSerieResponse {
        private Integer id;
        private Integer rutinaEjercicioId;
        private String ejercicioNombre;
        private Integer numeroSerie;
        private BigDecimal pesoKg;
        private Integer repsRealizadas;
        private Integer rir;

        public static RegistroSerieResponse from(RegistroSerie r) {
            return RegistroSerieResponse.builder()
                    .id(r.getId())
                    .rutinaEjercicioId(r.getRutinaEjercicio().getId())
                    .ejercicioNombre(r.getRutinaEjercicio().getEjercicio().getNombre())
                    .numeroSerie(r.getNumeroSerie())
                    .pesoKg(r.getPesoKg())
                    .repsRealizadas(r.getRepsRealizadas())
                    .rir(r.getRir())
                    .build();
        }
    }

    public static SesionResponse from(SesionEntrenamiento s) {
        List<RegistroSerieResponse> registros = s.getRegistros() == null
                ? Collections.emptyList()
                : s.getRegistros().stream().map(RegistroSerieResponse::from).toList();

        return SesionResponse.builder()
                .id(s.getId())
                .rutinaId(s.getRutina().getId())
                .rutinaNombre(s.getRutina().getNombre())
                .fecha(s.getFecha())
                .registros(registros)
                .build();
    }
}