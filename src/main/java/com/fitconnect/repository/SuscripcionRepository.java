package com.fitconnect.repository;

import com.fitconnect.entity.Suscripcion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SuscripcionRepository extends JpaRepository<Suscripcion, Integer> {
    List<Suscripcion> findByClienteIdAndEstado(Integer clienteId, Suscripcion.Estado estado);
    List<Suscripcion> findByEntrenadorIdAndEstado(Integer entrenadorId, Suscripcion.Estado estado);
    List<Suscripcion> findByClienteId(Integer clienteId);
    List<Suscripcion> findByEntrenadorId(Integer entrenadorId);
}