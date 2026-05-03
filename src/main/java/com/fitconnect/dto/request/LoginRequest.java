package com.fitconnect.dto.request;

import com.fitconnect.entity.User;
import jakarta.validation.constraints.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDate;

// ---- Login ----
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class LoginRequest {
    @Email(message = "Email no válido")
    @NotBlank(message = "El email es obligatorio")
    private String email;

    @NotBlank(message = "La contraseña es obligatoria")
    @Size(min = 6, message = "La contraseña debe tener al menos 6 caracteres")
    private String password;
}
