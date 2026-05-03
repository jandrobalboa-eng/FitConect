package com.fitconnect.dto.request;

import com.fitconnect.entity.User;
import jakarta.validation.constraints.*;
import lombok.*;
import java.math.BigDecimal;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class RegisterRequest {

    @NotBlank(message = "El nombre es obligatorio")
    private String nombre;

    @Email(message = "Email no válido")
    @NotBlank(message = "El email es obligatorio")
    private String email;

    @NotBlank(message = "La contraseña es obligatoria")
    @Size(min = 6, message = "Mínimo 6 caracteres")
    private String password;

    @NotNull(message = "El rol es obligatorio")
    private User.Rol rol;

    // Opcionales según rol
    private BigDecimal altura;
    private String objetivo;
    private String especialidad;
    private String biografia;
}
