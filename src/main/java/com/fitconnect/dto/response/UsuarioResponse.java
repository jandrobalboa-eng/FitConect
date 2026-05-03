package com.fitconnect.dto.response;

import com.fitconnect.entity.User;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class UsuarioResponse {

    private Integer id;
    private String email;
    private String nombre;
    private String rol;
    private LocalDateTime fechaRegistro;

    // Campos cliente
    private BigDecimal altura;
    private String objetivo;
    private LocalDate fechaInicio;

    // Campos entrenador
    private String especialidad;
    private String biografia;
    private BigDecimal valoracion;

    public static UsuarioResponse from(User user) {
        return UsuarioResponse.builder()
                .id(user.getId())
                .email(user.getEmail())
                .nombre(user.getNombre())
                .rol(user.getRol().name())
                .fechaRegistro(user.getFechaRegistro())
                .altura(user.getAltura())
                .objetivo(user.getObjetivo())
                .fechaInicio(user.getFechaInicio())
                .especialidad(user.getEspecialidad())
                .biografia(user.getBiografia())
                .valoracion(user.getValoracion())
                .build();
    }
}