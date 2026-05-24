package com.fitconnect.service;

import com.fitconnect.dto.request.SesionRequest;
import com.fitconnect.dto.response.SesionResponse;
import com.fitconnect.entity.RegistroSerie;
import com.fitconnect.entity.Rutina;
import com.fitconnect.entity.RutinaEjercicio;
import com.fitconnect.entity.SesionEntrenamiento;
import com.fitconnect.entity.User;
import com.fitconnect.repository.RutinaEjercicioRepository;
import com.fitconnect.repository.RutinaRepository;
import com.fitconnect.repository.SesionEntrenamientoRepository;
import com.fitconnect.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class SesionService {

    private final SesionEntrenamientoRepository sesionRepository;
    private final UserRepository userRepository;
    private final RutinaRepository rutinaRepository;
    private final RutinaEjercicioRepository rutinaEjercicioRepository;

    @Transactional
    public SesionResponse registrarSesion(String emailCliente, SesionRequest request) {
        User cliente = userRepository.findByEmail(emailCliente)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        Rutina rutina = rutinaRepository.findById(request.getRutinaId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Rutina no encontrada"));

        if (!rutina.getCliente().getId().equals(cliente.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Esta rutina no te pertenece");
        }

        SesionEntrenamiento sesion = SesionEntrenamiento.builder()
                .cliente(cliente)
                .rutina(rutina)
                .fecha(request.getFecha())
                .registros(new ArrayList<>())
                .build();

        for (SesionRequest.RegistroSerieRequest rsr : request.getRegistros()) {
            RutinaEjercicio rutinaEjercicio = rutinaEjercicioRepository.findById(rsr.getRutinaEjercicioId())
                    .orElseThrow(() -> new ResponseStatusException(
                            HttpStatus.NOT_FOUND, "Ejercicio de rutina no encontrado: " + rsr.getRutinaEjercicioId()));

            RegistroSerie registro = RegistroSerie.builder()
                    .sesion(sesion)
                    .rutinaEjercicio(rutinaEjercicio)
                    .numeroSerie(rsr.getNumeroSerie())
                    .pesoKg(rsr.getPesoKg())
                    .repsRealizadas(rsr.getRepsRealizadas())
                    .rir(rsr.getRir())
                    .build();

            sesion.getRegistros().add(registro);
        }

        return SesionResponse.from(sesionRepository.save(sesion));
    }

    public List<SesionResponse> getMisSesiones(String emailCliente) {
        User cliente = userRepository.findByEmail(emailCliente)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        return sesionRepository.findByClienteIdOrderByFechaDesc(cliente.getId())
                .stream()
                .map(SesionResponse::from)
                .toList();
    }

    public List<SesionResponse> getSesionesByCliente(String emailEntrenador, Integer clienteId) {
        User entrenador = userRepository.findByEmail(emailEntrenador)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        if (entrenador.getRol() != User.Rol.entrenador) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Solo los entrenadores pueden acceder a esta ruta");
        }

        return sesionRepository.findByClienteIdOrderByFechaDesc(clienteId)
                .stream()
                .map(SesionResponse::from)
                .toList();
    }
}