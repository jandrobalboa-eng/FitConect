package com.fitconnect.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.List;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class RutinaRequest {

    @NotNull(message = "El clienteId es obligatorio")
    private Integer clienteId;

    @NotBlank(message = "El nombre es obligatorio")
    private String nombre;

    private String descripcion;

    @Valid
    private List<RutinaEjercicioRequest> ejercicios;

    @Getter @Setter @NoArgsConstructor @AllArgsConstructor
    public static class RutinaEjercicioRequest {

        @NotNull(message = "El ejercicioId es obligatorio")
        private Integer ejercicioId;

        private Integer series;
        private String repeticiones;
        private String descanso;
        private String diaSemana;
    }
}