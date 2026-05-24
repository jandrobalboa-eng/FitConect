package com.fitconnect.controller;

import com.fitconnect.dto.request.SesionRequest;
import com.fitconnect.dto.response.ApiResponse;
import com.fitconnect.dto.response.SesionResponse;
import com.fitconnect.service.SesionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/sesiones")
@RequiredArgsConstructor
public class SesionController {

    private final SesionService sesionService;

    @PostMapping
    public ResponseEntity<ApiResponse<SesionResponse>> registrarSesion(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody SesionRequest request) {
        SesionResponse response = sesionService.registrarSesion(userDetails.getUsername(), request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok("Sesion registrada", response));
    }

    @GetMapping("/mis-sesiones")
    public ResponseEntity<ApiResponse<List<SesionResponse>>> getMisSesiones(
            @AuthenticationPrincipal UserDetails userDetails) {
        List<SesionResponse> sesiones = sesionService.getMisSesiones(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.ok("Sesiones obtenidas", sesiones));
    }

    @GetMapping("/cliente/{clienteId}")
    public ResponseEntity<ApiResponse<List<SesionResponse>>> getSesionesByCliente(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Integer clienteId) {
        List<SesionResponse> sesiones = sesionService.getSesionesByCliente(userDetails.getUsername(), clienteId);
        return ResponseEntity.ok(ApiResponse.ok("Sesiones del cliente obtenidas", sesiones));
    }
}