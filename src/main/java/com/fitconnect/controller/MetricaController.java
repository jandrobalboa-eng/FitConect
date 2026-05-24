package com.fitconnect.controller;

import com.fitconnect.dto.request.MetricaRequest;
import com.fitconnect.dto.response.ApiResponse;
import com.fitconnect.dto.response.MetricaResponse;
import com.fitconnect.service.MetricaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/metricas")
@RequiredArgsConstructor
public class MetricaController {

    private final MetricaService metricaService;

    @PostMapping
    public ResponseEntity<ApiResponse<MetricaResponse>> registrar(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody MetricaRequest request) {
        MetricaResponse response = metricaService.registrar(userDetails.getUsername(), request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok("Metrica registrada", response));
    }

    @GetMapping("/mis-metricas")
    public ResponseEntity<ApiResponse<List<MetricaResponse>>> getMisMetricas(
            @AuthenticationPrincipal UserDetails userDetails) {
        List<MetricaResponse> metricas = metricaService.getMisMetricas(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.ok("Metricas obtenidas", metricas));
    }

    @GetMapping("/cliente/{clienteId}")
    public ResponseEntity<ApiResponse<List<MetricaResponse>>> getMetricasByCliente(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Integer clienteId) {
        List<MetricaResponse> metricas = metricaService.getMetricasByCliente(userDetails.getUsername(), clienteId);
        return ResponseEntity.ok(ApiResponse.ok("Metricas del cliente obtenidas", metricas));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<MetricaResponse>> actualizar(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Integer id,
            @Valid @RequestBody MetricaRequest request) {
        MetricaResponse response = metricaService.actualizar(userDetails.getUsername(), id, request);
        return ResponseEntity.ok(ApiResponse.ok("Metrica actualizada", response));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> eliminar(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Integer id) {
        metricaService.eliminar(userDetails.getUsername(), id);
        return ResponseEntity.ok(ApiResponse.ok("Metrica eliminada", null));
    }
}