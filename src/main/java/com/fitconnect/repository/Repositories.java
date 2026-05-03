package com.fitconnect.repository;

import com.fitconnect.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

// UserRepository     → UserRepository.java
// RutinaRepository   → RutinaRepository.java
// EjercicioRepository → EjercicioRepository.java

@Repository
interface MetricaCorporalRepository extends JpaRepository<MetricaCorporal, Integer> {
    List<MetricaCorporal> findByClienteIdOrderByFechaDesc(Integer clienteId);
}

@Repository
interface SuscripcionRepository extends JpaRepository<Suscripcion, Integer> {
    Optional<Suscripcion> findByClienteIdAndEntrenadorIdAndEstado(
        Integer clienteId, Integer entrenadorId, Suscripcion.Estado estado);
    List<Suscripcion> findByClienteId(Integer clienteId);
    List<Suscripcion> findByEntrenadorId(Integer entrenadorId);
}

@Repository
interface PlanAlimentacionRepository extends JpaRepository<PlanAlimentacion, Integer> {
    List<PlanAlimentacion> findByClienteId(Integer clienteId);
    List<PlanAlimentacion> findByEntrenadorId(Integer entrenadorId);
}

@Repository
interface ConversacionRepository extends JpaRepository<Conversacion, Integer> {
    Optional<Conversacion> findByClienteIdAndEntrenadorId(Integer clienteId, Integer entrenadorId);
    List<Conversacion> findByClienteIdOrEntrenadorId(Integer clienteId, Integer entrenadorId);
}

@Repository
interface MensajeRepository extends JpaRepository<Mensaje, Integer> {
    List<Mensaje> findByConversacionIdOrderByFechaEnvioAsc(Integer conversacionId);
}