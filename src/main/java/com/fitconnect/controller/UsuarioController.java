package com.fitconnect.controller;

import com.fitconnect.dto.response.ApiResponse;
import com.fitconnect.dto.response.UsuarioResponse;
import com.fitconnect.service.UsuarioService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/usuarios")
@RequiredArgsConstructor
public class UsuarioController {

    private final UsuarioService usuarioService;

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<UsuarioResponse>> getMiPerfil(
            @AuthenticationPrincipal UserDetails userDetails) {
        UsuarioResponse response = usuarioService.getMiPerfil(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.ok("Perfil obtenido", response));
    }

    @GetMapping("/clientes")
    public ResponseEntity<ApiResponse<List<UsuarioResponse>>> getClientesDelEntrenador(
            @AuthenticationPrincipal UserDetails userDetails) {
        List<UsuarioResponse> clientes = usuarioService.getClientesDelEntrenador(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.ok("Clientes obtenidos", clientes));
    }
}