package com.fitconnect.service;

import com.fitconnect.dto.request.MetricaRequest;
import com.fitconnect.dto.response.MetricaResponse;
import com.fitconnect.entity.MetricaCorporal;
import com.fitconnect.entity.User;
import com.fitconnect.repository.MetricaCorporalRepository;
import com.fitconnect.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MetricaService {

    private final MetricaCorporalRepository metricaRepository;
    private final UserRepository userRepository;

    public MetricaResponse registrar(String email, MetricaRequest request) {
        User cliente = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        MetricaCorporal metrica = MetricaCorporal.builder()
                .cliente(cliente)
                .fecha(request.getFecha())
                .peso(request.getPeso())
                .medidaCintura(request.getMedidaCintura())
                .medidaCadera(request.getMedidaCadera())
                .notas(request.getNotas())
                .build();

        return MetricaResponse.from(metricaRepository.save(metrica));
    }

    public List<MetricaResponse> getMisMetricas(String email) {
        User cliente = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        return metricaRepository.findByClienteIdOrderByFechaDesc(cliente.getId())
                .stream()
                .map(MetricaResponse::from)
                .toList();
    }

    public List<MetricaResponse> getMetricasByCliente(String emailEntrenador, Integer clienteId) {
        User entrenador = userRepository.findByEmail(emailEntrenador)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        if (entrenador.getRol() != User.Rol.entrenador) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Solo los entrenadores pueden acceder a esta ruta");
        }

        return metricaRepository.findByClienteIdOrderByFechaDesc(clienteId)
                .stream()
                .map(MetricaResponse::from)
                .toList();
    }

    @Transactional
    public MetricaResponse actualizar(String email, Integer id, MetricaRequest request) {
        User cliente = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        MetricaCorporal metrica = metricaRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Metrica no encontrada"));

        if (!metrica.getCliente().getId().equals(cliente.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "No puedes editar esta metrica");
        }

        metrica.setFecha(request.getFecha());
        metrica.setPeso(request.getPeso());
        metrica.setMedidaCintura(request.getMedidaCintura());
        metrica.setMedidaCadera(request.getMedidaCadera());
        metrica.setNotas(request.getNotas());

        return MetricaResponse.from(metricaRepository.save(metrica));
    }

    @Transactional
    public void eliminar(String email, Integer id) {
        User cliente = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        MetricaCorporal metrica = metricaRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Metrica no encontrada"));

        if (!metrica.getCliente().getId().equals(cliente.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "No puedes eliminar esta metrica");
        }

        metricaRepository.delete(metrica);
    }
}