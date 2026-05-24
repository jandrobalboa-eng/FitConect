package com.fitconnect.repository;

import com.fitconnect.entity.RutinaEjercicio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RutinaEjercicioRepository extends JpaRepository<RutinaEjercicio, Integer> {
}