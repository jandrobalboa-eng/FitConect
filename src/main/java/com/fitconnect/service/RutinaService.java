package com.fitconnect.service;

import com.fitconnect.dto.request.RutinaRequest;
import com.fitconnect.dto.response.RutinaResponse;
import com.fitconnect.entity.Ejercicio;
import com.fitconnect.entity.Rutina;
import com.fitconnect.entity.RutinaEjercicio;
import com.fitconnect.entity.User;
import com.fitconnect.repository.EjercicioRepository;
import com.fitconnect.repository.RutinaRepository;
import com.fitconnect.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class RutinaService {

    private final RutinaRepository rutinaRepository;
    private final UserRepository userRepository;
    private final EjercicioRepository ejercicioRepository;

    @Transactional
    public RutinaResponse crearRutina(String emailEntrenador, RutinaRequest request) {
        User entrenador = userRepository.findByEmail(emailEntrenador)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        if (entrenador.getRol() != User.Rol.entrenador) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Solo los entrenadores pueden crear rutinas");
        }

        User cliente = userRepository.findById(request.getClienteId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Cliente no encontrado"));

        Rutina rutina = Rutina.builder()
                .entrenador(entrenador)
                .cliente(cliente)
                .nombre(request.getNombre())
                .descripcion(request.getDescripcion())
                .fechaAsignacion(LocalDate.now())
                .ejercicios(new ArrayList<>())
                .build();

        if (request.getEjercicios() != null) {
            for (RutinaRequest.RutinaEjercicioRequest re : request.getEjercicios()) {
                Ejercicio ejercicio = ejercicioRepository.findById(re.getEjercicioId())
                        .orElseThrow(() -> new ResponseStatusException(
                                HttpStatus.NOT_FOUND, "Ejercicio no encontrado: " + re.getEjercicioId()));

                RutinaEjercicio rutinaEjercicio = RutinaEjercicio.builder()
                        .rutina(rutina)
                        .ejercicio(ejercicio)
                        .series(re.getSeries())
                        .repeticiones(re.getRepeticiones())
                        .descanso(re.getDescanso())
                        .diaSemana(re.getDiaSemana() != null
                                ? RutinaEjercicio.DiaSemana.valueOf(re.getDiaSemana())
                                : null)
                        .build();

                rutina.getEjercicios().add(rutinaEjercicio);
            }
        }

        return RutinaResponse.from(rutinaRepository.save(rutina));
    }

    public List<RutinaResponse> getMisRutinas(String emailCliente) {
        User cliente = userRepository.findByEmail(emailCliente)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        return rutinaRepository.findByClienteId(cliente.getId())
                .stream()
                .map(RutinaResponse::from)
                .toList();
    }

    public List<RutinaResponse> getRutinasByCliente(String emailEntrenador, Integer clienteId) {
        User entrenador = userRepository.findByEmail(emailEntrenador)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        if (entrenador.getRol() != User.Rol.entrenador) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Solo los entrenadores pueden acceder a esta ruta");
        }

        return rutinaRepository.findByClienteId(clienteId)
                .stream()
                .map(RutinaResponse::from)
                .toList();
    }
}