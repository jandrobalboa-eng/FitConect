package com.fitconnect.dto.response;

import lombok.*;

// Respuesta estándar de login/registro
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class AuthResponse {
    private String token;
    private String email;
    private String nombre;
    private String rol;
    private Integer id;
}
