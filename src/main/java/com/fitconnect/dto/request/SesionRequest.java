package com.fitconnect.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Getter @Setter @NoArgsConstructor
public class SesionRequest {

    @NotNull(message = "El rutinaId es obligatorio")
    private Integer rutinaId;

    @NotNull(message = "La fecha es obligatoria")
    private LocalDate fecha;

    @Valid
    @NotNull
    private List<RegistroSerieRequest> registros;

    @Getter @Setter @NoArgsConstructor
    public static class RegistroSerieRequest {

        @NotNull(message = "El rutinaEjercicioId es obligatorio")
        private Integer rutinaEjercicioId;

        @NotNull(message = "El numeroSerie es obligatorio")
        private Integer numeroSerie;

        private BigDecimal pesoKg;
        private Integer repsRealizadas;
        private Integer rir;
    }
}