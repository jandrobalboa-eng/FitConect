package com.fitconnect.controller;

import com.fitconnect.dto.request.SuscripcionRequest;
import com.fitconnect.dto.response.ApiResponse;
import com.fitconnect.dto.response.SuscripcionResponse;
import com.fitconnect.service.SuscripcionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/suscripciones")
@RequiredArgsConstructor
public class SuscripcionController {

    private final SuscripcionService suscripcionService;

    @PostMapping
    public ResponseEntity<ApiResponse<SuscripcionResponse>> enviarSolicitud(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody SuscripcionRequest request) {
        SuscripcionResponse response = suscripcionService.enviarSolicitud(userDetails.getUsername(), request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok("Solicitud enviada", response));
    }

    @GetMapping("/pendientes")
    public ResponseEntity<ApiResponse<List<SuscripcionResponse>>> getPendientes(
            @AuthenticationPrincipal UserDetails userDetails) {
        List<SuscripcionResponse> pendientes = suscripcionService.getPendientes(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.ok("Solicitudes pendientes", pendientes));
    }

    @PutMapping("/{id}/aceptar")
    public ResponseEntity<ApiResponse<SuscripcionResponse>> aceptar(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Integer id) {
        SuscripcionResponse response = suscripcionService.aceptar(userDetails.getUsername(), id);
        return ResponseEntity.ok(ApiResponse.ok("Suscripcion aceptada", response));
    }

    @GetMapping("/mis-clientes")
    public ResponseEntity<ApiResponse<List<SuscripcionResponse>>> getMisClientes(
            @AuthenticationPrincipal UserDetails userDetails) {
        List<SuscripcionResponse> clientes = suscripcionService.getMisClientes(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.ok("Clientes activos", clientes));
    }
}