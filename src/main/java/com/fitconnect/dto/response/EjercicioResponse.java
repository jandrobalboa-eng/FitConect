package com.fitconnect.dto.response;

import com.fitconnect.entity.Ejercicio;
import lombok.*;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class EjercicioResponse {

    private Integer id;
    private String nombre;
    private String descripcion;
    private String gifUrl;
    private String musculoObjetivo;
    private Boolean esPredefinido;

    public static EjercicioResponse from(Ejercicio ejercicio) {
        return EjercicioResponse.builder()
                .id(ejercicio.getId())
                .nombre(ejercicio.getNombre())
                .descripcion(ejercicio.getDescripcion())
                .gifUrl(ejercicio.getGifUrl())
                .musculoObjetivo(ejercicio.getMusculoObjetivo())
                .esPredefinido(ejercicio.getEsPredefinido())
                .build();
    }
}