package com.fitconnect.repository;

import com.fitconnect.entity.Ejercicio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EjercicioRepository extends JpaRepository<Ejercicio, Integer> {
    List<Ejercicio> findByEsPredefinidoTrue();
    List<Ejercicio> findByCreadoPorId(Integer entrenadorId);
    List<Ejercicio> findByMusculoObjetivoContainingIgnoreCase(String musculo);

    @Query("SELECT e FROM Ejercicio e WHERE e.esPredefinido = true OR e.creadoPor.id = :entrenadorId")
    List<Ejercicio> findCatalogoParaEntrenador(@Param("entrenadorId") Integer entrenadorId);
}