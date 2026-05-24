package com.fitconnect.controller;

import com.fitconnect.dto.request.RutinaRequest;
import com.fitconnect.dto.response.ApiResponse;
import com.fitconnect.dto.response.RutinaResponse;
import com.fitconnect.service.RutinaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/rutinas")
@RequiredArgsConstructor
public class RutinaController {

    private final RutinaService rutinaService;

    @PostMapping
    public ResponseEntity<ApiResponse<RutinaResponse>> crearRutina(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody RutinaRequest request) {
        RutinaResponse response = rutinaService.crearRutina(userDetails.getUsername(), request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok("Rutina creada correctamente", response));
    }

    @GetMapping("/mis-rutinas")
    public ResponseEntity<ApiResponse<List<RutinaResponse>>> getMisRutinas(
            @AuthenticationPrincipal UserDetails userDetails) {
        List<RutinaResponse> rutinas = rutinaService.getMisRutinas(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.ok("Rutinas obtenidas", rutinas));
    }

    @GetMapping("/cliente/{clienteId}")
    public ResponseEntity<ApiResponse<List<RutinaResponse>>> getRutinasByCliente(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Integer clienteId) {
        List<RutinaResponse> rutinas = rutinaService.getRutinasByCliente(userDetails.getUsername(), clienteId);
        return ResponseEntity.ok(ApiResponse.ok("Rutinas del cliente obtenidas", rutinas));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<RutinaResponse>> actualizar(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Integer id,
            @Valid @RequestBody RutinaRequest request) {
        RutinaResponse response = rutinaService.actualizar(userDetails.getUsername(), id, request);
        return ResponseEntity.ok(ApiResponse.ok("Rutina actualizada", response));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> eliminar(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Integer id) {
        rutinaService.eliminar(userDetails.getUsername(), id);
        return ResponseEntity.ok(ApiResponse.ok("Rutina eliminada", null));
    }
}