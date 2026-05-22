package com.fitconnect.controller;

import com.fitconnect.dto.response.ApiResponse;
import com.fitconnect.entity.PlanSuscripcion;
import com.fitconnect.entity.SuscripcionEntrenador;
import com.fitconnect.entity.User;
import com.fitconnect.service.PlanService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/planes")
@RequiredArgsConstructor
public class PlanController {

    private final PlanService planService;

    /**
     * GET /api/planes/catalogo
     * Público - muestra los planes disponibles con precios y features
     */
    @GetMapping("/catalogo")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getCatalogo() {
        List<Map<String, Object>> catalogo = List.of(
            Map.of(
                "tipo", "BASICO",
                "nombre", "Básico",
                "precio", 9.00,
                "maxClientes", 5,
                "descripcion", "Perfecto para empezar tu carrera como entrenador online",
                "features", List.of(
                    "Hasta 5 clientes",
                    "Rutinas personalizadas",
                    "Chat con clientes",
                    "Soporte por email"
                ),
                "destacado", false
            ),
            Map.of(
                "tipo", "PRO",
                "nombre", "Pro",
                "precio", 19.00,
                "maxClientes", 15,
                "descripcion", "Para entrenadores en crecimiento con más clientes",
                "features", List.of(
                    "Hasta 15 clientes",
                    "Todo lo del Básico",
                    "Planes de alimentación",
                    "Métricas avanzadas",
                    "Soporte prioritario"
                ),
                "destacado", true
            ),
            Map.of(
                "tipo", "PREMIUM",
                "nombre", "Premium",
                "precio", 39.00,
                "maxClientes", 999,
                "descripcion", "Sin límites para entrenadores profesionales",
                "features", List.of(
                    "Clientes ilimitados",
                    "Todo lo del Pro",
                    "Informes semanales automáticos",
                    "Acceso API",
                    "Soporte 24/7"
                ),
                "destacado", false
            )
        );
        return ResponseEntity.ok(ApiResponse.ok("Planes disponibles", catalogo));
    }

    /**
     * POST /api/planes/suscribir/{tipoPlan}
     * Entrenador autenticado se suscribe a un plan
     */
    @PostMapping("/suscribir/{tipoPlan}")
    @PreAuthorize("hasRole('ENTRENADOR')")
    public ResponseEntity<ApiResponse<String>> suscribir(
            @AuthenticationPrincipal User user,
            @PathVariable String tipoPlan) {

        PlanSuscripcion.TipoPlan plan = PlanSuscripcion.TipoPlan.valueOf(tipoPlan.toUpperCase());
        SuscripcionEntrenador s = planService.suscribir(user.getId(), plan);
        return ResponseEntity.ok(ApiResponse.ok(
            "Suscripción al plan " + plan.name() + " activada correctamente",
            "OK"
        ));
    }

    /**
     * GET /api/planes/mi-plan
     * Entrenador autenticado consulta su plan actual
     */
    @GetMapping("/mi-plan")
    @PreAuthorize("hasRole('ENTRENADOR')")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getMiPlan(
            @AuthenticationPrincipal User user) {
        return ResponseEntity.ok(ApiResponse.ok(planService.getMiPlan(user.getId())));
    }

    /**
     * GET /api/planes/stats
     * Solo admin - estadísticas financieras de la plataforma
     */
    @GetMapping("/stats")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getStats() {
        return ResponseEntity.ok(ApiResponse.ok(planService.getStatsFinancieras()));
    }
}