package com.fitconnect.repository;

import com.fitconnect.entity.SuscripcionEntrenador;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface SuscripcionEntrenadorRepository extends JpaRepository<SuscripcionEntrenador, Integer> {

    Optional<SuscripcionEntrenador> findByEntrenadorId(Integer entrenadorId);

    @Query("SELECT COUNT(s) FROM SuscripcionEntrenador s WHERE s.estado = 'ACTIVA'")
    long countActivas();

    @Query("SELECT COUNT(s) FROM SuscripcionEntrenador s WHERE s.plan = 'BASICO' AND s.estado = 'ACTIVA'")
    long countBasico();

    @Query("SELECT COUNT(s) FROM SuscripcionEntrenador s WHERE s.plan = 'PRO' AND s.estado = 'ACTIVA'")
    long countPro();

    @Query("SELECT COUNT(s) FROM SuscripcionEntrenador s WHERE s.plan = 'PREMIUM' AND s.estado = 'ACTIVA'")
    long countPremium();
}
