package com.fitconnect.repository;

import com.fitconnect.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

// ============================================================
// USER
// ============================================================
@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
    Optional<User> findByEmail(String email);
    boolean existsByEmail(String email);
    List<User> findByRol(User.Rol rol);

    // Clientes de un entrenador (a través de suscripciones activas)
    @Query("SELECT s.cliente FROM Suscripcion s WHERE s.entrenador.id = :entrenadorId AND s.estado = 'Activa'")
    List<User> findClientesByEntrenadorId(@Param("entrenadorId") Integer entrenadorId);
}

// ============================================================
// RUTINA
// ============================================================
@Repository
interface RutinaRepository extends JpaRepository<Rutina, Integer> {
    List<Rutina> findByClienteId(Integer clienteId);
    List<Rutina> findByEntrenadorId(Integer entrenadorId);
    List<Rutina> findByClienteIdAndEntrenadorId(Integer clienteId, Integer entrenadorId);
}

// ============================================================
// EJERCICIO
// ============================================================
@Repository
interface EjercicioRepository extends JpaRepository<Ejercicio, Integer> {
    List<Ejercicio> findByEsPredefinidoTrue();
    List<Ejercicio> findByCreadoPorId(Integer entrenadorId);
    List<Ejercicio> findByMusculoObjetivoContainingIgnoreCase(String musculo);

    @Query("SELECT e FROM Ejercicio e WHERE e.esPredefinido = true OR e.creadoPor.id = :entrenadorId")
    List<Ejercicio> findCatalogoParaEntrenador(@Param("entrenadorId") Integer entrenadorId);
}

// ============================================================
// METRICA CORPORAL
// ============================================================
@Repository
interface MetricaCorporalRepository extends JpaRepository<MetricaCorporal, Integer> {
    List<MetricaCorporal> findByClienteIdOrderByFechaDesc(Integer clienteId);
}

// ============================================================
// SUSCRIPCION
// ============================================================
@Repository
interface SuscripcionRepository extends JpaRepository<Suscripcion, Integer> {
    Optional<Suscripcion> findByClienteIdAndEntrenadorIdAndEstado(
        Integer clienteId, Integer entrenadorId, Suscripcion.Estado estado);
    List<Suscripcion> findByClienteId(Integer clienteId);
    List<Suscripcion> findByEntrenadorId(Integer entrenadorId);
}

// ============================================================
// PLAN ALIMENTACION
// ============================================================
@Repository
interface PlanAlimentacionRepository extends JpaRepository<PlanAlimentacion, Integer> {
    List<PlanAlimentacion> findByClienteId(Integer clienteId);
    List<PlanAlimentacion> findByEntrenadorId(Integer entrenadorId);
}

// ============================================================
// CONVERSACION
// ============================================================
@Repository
interface ConversacionRepository extends JpaRepository<Conversacion, Integer> {
    Optional<Conversacion> findByClienteIdAndEntrenadorId(Integer clienteId, Integer entrenadorId);
    List<Conversacion> findByClienteIdOrEntrenadorId(Integer clienteId, Integer entrenadorId);
}

// ============================================================
// MENSAJE
// ============================================================
@Repository
interface MensajeRepository extends JpaRepository<Mensaje, Integer> {
    List<Mensaje> findByConversacionIdOrderByFechaEnvioAsc(Integer conversacionId);
}
