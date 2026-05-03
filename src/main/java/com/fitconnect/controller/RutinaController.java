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
}