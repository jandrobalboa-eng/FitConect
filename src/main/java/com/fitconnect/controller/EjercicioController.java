package com.fitconnect.controller;

import com.fitconnect.dto.response.ApiResponse;
import com.fitconnect.dto.response.EjercicioResponse;
import com.fitconnect.service.EjercicioService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ejercicios")
@RequiredArgsConstructor
public class EjercicioController {

    private final EjercicioService ejercicioService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<EjercicioResponse>>> getCatalogo(
            @AuthenticationPrincipal UserDetails userDetails) {
        List<EjercicioResponse> ejercicios = ejercicioService.getCatalogo(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.ok("Catálogo obtenido", ejercicios));
    }
}