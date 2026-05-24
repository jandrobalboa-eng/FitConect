package com.fitconnect.repository;

import com.fitconnect.entity.SesionEntrenamiento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SesionEntrenamientoRepository extends JpaRepository<SesionEntrenamiento, Integer> {
    List<SesionEntrenamiento> findByClienteIdOrderByFechaDesc(Integer clienteId);
    List<SesionEntrenamiento> findByRutinaIdAndClienteIdOrderByFechaDesc(Integer rutinaId, Integer clienteId);
}