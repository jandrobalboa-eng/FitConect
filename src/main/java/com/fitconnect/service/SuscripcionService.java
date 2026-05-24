package com.fitconnect.service;

import com.fitconnect.dto.request.SuscripcionRequest;
import com.fitconnect.dto.response.SuscripcionResponse;
import com.fitconnect.entity.Suscripcion;
import com.fitconnect.entity.User;
import com.fitconnect.repository.SuscripcionRepository;
import com.fitconnect.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SuscripcionService {

    private final SuscripcionRepository suscripcionRepository;
    private final UserRepository userRepository;

    @Transactional
    public SuscripcionResponse enviarSolicitud(String emailEntrenador, SuscripcionRequest request) {
        User entrenador = userRepository.findByEmail(emailEntrenador)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        if (entrenador.getRol() != User.Rol.entrenador) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Solo los entrenadores pueden enviar solicitudes");
        }

        User cliente = userRepository.findByEmail(request.getClienteEmail())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Cliente no encontrado"));

        if (cliente.getRol() != User.Rol.cliente) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "El destinatario debe ser un cliente");
        }

        Suscripcion.TipoPago tipoPago;
        try {
            tipoPago = Suscripcion.TipoPago.valueOf(request.getTipoPago());
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "tipoPago debe ser Mensual o Anual");
        }

        Suscripcion suscripcion = Suscripcion.builder()
                .entrenador(entrenador)
                .cliente(cliente)
                .fechaInicio(request.getFechaInicio())
                .fechaFin(request.getFechaFin())
                .tipoPago(tipoPago)
                .estado(Suscripcion.Estado.Pendiente)
                .build();

        return SuscripcionResponse.from(suscripcionRepository.save(suscripcion));
    }

    public List<SuscripcionResponse> getPendientes(String emailCliente) {
        User cliente = userRepository.findByEmail(emailCliente)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        return suscripcionRepository.findByClienteIdAndEstado(cliente.getId(), Suscripcion.Estado.Pendiente)
                .stream()
                .map(SuscripcionResponse::from)
                .toList();
    }

    @Transactional
    public SuscripcionResponse aceptar(String emailCliente, Integer suscripcionId) {
        User cliente = userRepository.findByEmail(emailCliente)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        Suscripcion suscripcion = suscripcionRepository.findById(suscripcionId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Suscripcion no encontrada"));

        if (!suscripcion.getCliente().getId().equals(cliente.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "No puedes aceptar esta suscripcion");
        }

        if (suscripcion.getEstado() != Suscripcion.Estado.Pendiente) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "La suscripcion no esta en estado pendiente");
        }

        suscripcion.setEstado(Suscripcion.Estado.Activa);
        return SuscripcionResponse.from(suscripcionRepository.save(suscripcion));
    }

    public List<SuscripcionResponse> getMisClientes(String emailEntrenador) {
        User entrenador = userRepository.findByEmail(emailEntrenador)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        if (entrenador.getRol() != User.Rol.entrenador) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Solo los entrenadores pueden acceder a esta ruta");
        }

        return suscripcionRepository.findByEntrenadorIdAndEstado(entrenador.getId(), Suscripcion.Estado.Activa)
                .stream()
                .map(SuscripcionResponse::from)
                .toList();
    }
}