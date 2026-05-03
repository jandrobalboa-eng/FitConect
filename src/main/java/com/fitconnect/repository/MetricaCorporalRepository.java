package com.fitconnect.repository;

import com.fitconnect.entity.MetricaCorporal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MetricaCorporalRepository extends JpaRepository<MetricaCorporal, Integer> {
    List<MetricaCorporal> findByClienteIdOrderByFechaDesc(Integer clienteId);
}