package com.fitconnect.repository;

import com.fitconnect.entity.Rutina;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RutinaRepository extends JpaRepository<Rutina, Integer> {
    List<Rutina> findByClienteId(Integer clienteId);
    List<Rutina> findByEntrenadorId(Integer entrenadorId);
    List<Rutina> findByClienteIdAndEntrenadorId(Integer clienteId, Integer entrenadorId);
}