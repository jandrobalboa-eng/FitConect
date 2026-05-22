package com.fitconnect.service;

import com.fitconnect.entity.PlanSuscripcion;
import com.fitconnect.entity.SuscripcionEntrenador;
import com.fitconnect.entity.User;
import com.fitconnect.repository.SuscripcionEntrenadorRepository;
import com.fitconnect.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class PlanService {

    private final SuscripcionEntrenadorRepository suscripcionEntrenadorRepository;
    private final UserRepository userRepository;

    // ── Precios y límites de cada plan ──────────────────────────────────────
    public static final Map<PlanSuscripcion.TipoPlan, BigDecimal> PRECIOS = Map.of(
        PlanSuscripcion.TipoPlan.BASICO,   new BigDecimal("9.00"),
        PlanSuscripcion.TipoPlan.PRO,      new BigDecimal("19.00"),
        PlanSuscripcion.TipoPlan.PREMIUM,  new BigDecimal("39.00")
    );

    public static final Map<PlanSuscripcion.TipoPlan, Integer> MAX_CLIENTES = Map.of(
        PlanSuscripcion.TipoPlan.BASICO,   5,
        PlanSuscripcion.TipoPlan.PRO,      15,
        PlanSuscripcion.TipoPlan.PREMIUM,  999
    );

    public static final Map<PlanSuscripcion.TipoPlan, List<String>> FEATURES = Map.of(
        PlanSuscripcion.TipoPlan.BASICO,  List.of(
            "Hasta 5 clientes", "Rutinas personalizadas", "Chat con clientes", "Soporte por email"
        ),
        PlanSuscripcion.TipoPlan.PRO,     List.of(
            "Hasta 15 clientes", "Todo lo del Básico", "Planes de alimentación", "Métricas avanzadas", "Soporte prioritario"
        ),
        PlanSuscripcion.TipoPlan.PREMIUM, List.of(
            "Clientes ilimitados", "Todo lo del Pro", "Informes semanales automáticos", "API acceso", "Soporte 24/7"
        )
    );

    // ── Suscribir entrenador a un plan ───────────────────────────────────────
    public SuscripcionEntrenador suscribir(Integer entrenadorId, PlanSuscripcion.TipoPlan plan) {
        User entrenador = userRepository.findById(entrenadorId)
            .orElseThrow(() -> new RuntimeException("Entrenador no encontrado"));

        if (entrenador.getRol() != User.Rol.entrenador) {
            throw new RuntimeException("Solo los entrenadores pueden suscribirse a un plan");
        }

        // Si ya tiene plan, actualizarlo
        SuscripcionEntrenador suscripcion = suscripcionEntrenadorRepository
            .findByEntrenadorId(entrenadorId)
            .orElse(SuscripcionEntrenador.builder().entrenador(entrenador).build());

        suscripcion.setPlan(plan);
        suscripcion.setFechaInicio(LocalDate.now());
        suscripcion.setFechaFin(LocalDate.now().plusMonths(1));
        suscripcion.setEstado(SuscripcionEntrenador.Estado.ACTIVA);

        return suscripcionEntrenadorRepository.save(suscripcion);
    }

    // ── Plan actual del entrenador ───────────────────────────────────────────
    public Map<String, Object> getMiPlan(Integer entrenadorId) {
        return suscripcionEntrenadorRepository.findByEntrenadorId(entrenadorId)
            .map(s -> {
                Map<String, Object> info = new LinkedHashMap<>();
                info.put("plan", s.getPlan().name());
                info.put("estado", s.getEstado().name());
                info.put("fechaInicio", s.getFechaInicio());
                info.put("fechaFin", s.getFechaFin());
                info.put("precio", PRECIOS.get(s.getPlan()));
                info.put("maxClientes", MAX_CLIENTES.get(s.getPlan()));
                info.put("features", FEATURES.get(s.getPlan()));
                return info;
            })
            .orElse(Map.of("plan", "SIN_PLAN", "mensaje", "No tienes ningún plan activo"));
    }

    // ── Stats financieras para el dashboard admin ────────────────────────────
    public Map<String, Object> getStatsFinancieras() {
        long basico   = suscripcionEntrenadorRepository.countBasico();
        long pro      = suscripcionEntrenadorRepository.countPro();
        long premium  = suscripcionEntrenadorRepository.countPremium();
        long total    = basico + pro + premium;

        BigDecimal mrr = BigDecimal.ZERO
            .add(new BigDecimal(basico).multiply(PRECIOS.get(PlanSuscripcion.TipoPlan.BASICO)))
            .add(new BigDecimal(pro).multiply(PRECIOS.get(PlanSuscripcion.TipoPlan.PRO)))
            .add(new BigDecimal(premium).multiply(PRECIOS.get(PlanSuscripcion.TipoPlan.PREMIUM)));

        BigDecimal arr = mrr.multiply(new BigDecimal("12"));

        long totalUsuarios     = userRepository.count();
        long totalEntrenadores = userRepository.findByRol(User.Rol.entrenador).size();
        long totalClientes     = userRepository.findByRol(User.Rol.cliente).size();

        Map<String, Object> stats = new LinkedHashMap<>();
        stats.put("mrr", mrr);                          // Monthly Recurring Revenue
        stats.put("arr", arr);                          // Annual Recurring Revenue
        stats.put("totalSuscripciones", total);
        stats.put("distribucion", Map.of(
            "basico",   Map.of("cantidad", basico,  "precio", PRECIOS.get(PlanSuscripcion.TipoPlan.BASICO),  "ingresos", new BigDecimal(basico).multiply(PRECIOS.get(PlanSuscripcion.TipoPlan.BASICO))),
            "pro",      Map.of("cantidad", pro,     "precio", PRECIOS.get(PlanSuscripcion.TipoPlan.PRO),     "ingresos", new BigDecimal(pro).multiply(PRECIOS.get(PlanSuscripcion.TipoPlan.PRO))),
            "premium",  Map.of("cantidad", premium, "precio", PRECIOS.get(PlanSuscripcion.TipoPlan.PREMIUM), "ingresos", new BigDecimal(premium).multiply(PRECIOS.get(PlanSuscripcion.TipoPlan.PREMIUM)))
        ));
        stats.put("usuarios", Map.of(
            "total", totalUsuarios,
            "entrenadores", totalEntrenadores,
            "clientes", totalClientes
        ));
        stats.put("ticketMedio", total > 0 ? mrr.divide(new BigDecimal(total), 2, java.math.RoundingMode.HALF_UP) : BigDecimal.ZERO);

        return stats;
    }
}