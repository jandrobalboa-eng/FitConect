package com.fitconnect.dto.response;

import com.fitconnect.entity.Rutina;
import com.fitconnect.entity.RutinaEjercicio;
import lombok.*;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class RutinaResponse {

    private Integer id;
    private String nombre;
    private String descripcion;
    private LocalDate fechaAsignacion;
    private String entrenadorNombre;
    private String clienteNombre;
    private List<EjercicioEnRutinaResponse> ejercicios;

    @Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
    public static class EjercicioEnRutinaResponse {
        private Integer id;
        private String nombre;
        private String musculoObjetivo;
        private String gifUrl;
        private Integer series;
        private String repeticiones;
        private String descanso;
        private String diaSemana;

        public static EjercicioEnRutinaResponse from(RutinaEjercicio re) {
            return EjercicioEnRutinaResponse.builder()
                    .id(re.getId())
                    .nombre(re.getEjercicio().getNombre())
                    .musculoObjetivo(re.getEjercicio().getMusculoObjetivo())
                    .gifUrl(re.getEjercicio().getGifUrl())
                    .series(re.getSeries())
                    .repeticiones(re.getRepeticiones())
                    .descanso(re.getDescanso())
                    .diaSemana(re.getDiaSemana() != null ? re.getDiaSemana().name() : null)
                    .build();
        }
    }

    public static RutinaResponse from(Rutina rutina) {
        List<EjercicioEnRutinaResponse> ejercicios = rutina.getEjercicios() == null
                ? Collections.emptyList()
                : rutina.getEjercicios().stream().map(EjercicioEnRutinaResponse::from).toList();

        return RutinaResponse.builder()
                .id(rutina.getId())
                .nombre(rutina.getNombre())
                .descripcion(rutina.getDescripcion())
                .fechaAsignacion(rutina.getFechaAsignacion())
                .entrenadorNombre(rutina.getEntrenador().getNombre())
                .clienteNombre(rutina.getCliente().getNombre())
                .ejercicios(ejercicios)
                .build();
    }
}