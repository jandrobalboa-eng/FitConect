package com.fitconnect.controller;

import com.fitconnect.dto.request.LoginRequest;
import com.fitconnect.dto.request.RegisterRequest;
import com.fitconnect.dto.response.ApiResponse;
import com.fitconnect.dto.response.AuthResponse;
import com.fitconnect.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    /**
     * POST /api/auth/register
     * Body: { "nombre": "Alex", "email": "alex@gmail.com", "password": "123456", "rol": "entrenador" }
     * Response: { "success": true, "data": { "token": "...", "rol": "entrenador", ... } }
     */
    @PostMapping("/register")
    public ResponseEntity<ApiResponse<AuthResponse>> register(
            @Valid @RequestBody RegisterRequest request) {
        AuthResponse response = authService.register(request);
        return ResponseEntity.ok(ApiResponse.ok("Usuario registrado correctamente", response));
    }

    /**
     * POST /api/auth/login
     * Body: { "email": "alex@gmail.com", "password": "123456" }
     * Response: { "success": true, "data": { "token": "...", "rol": "entrenador", ... } }
     */
    @PostMapping("/login")
    public ResponseEntity<ApiResponse<AuthResponse>> login(
            @Valid @RequestBody LoginRequest request) {
        AuthResponse response = authService.login(request);
        return ResponseEntity.ok(ApiResponse.ok("Login correcto", response));
    }

    /**
     * GET /api/health
     * Para comprobar que el servidor está vivo
     */
    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("FitConnect API funcionando");
    }
}
