package com.fitconnect.service;

import com.fitconnect.dto.response.UsuarioResponse;
import com.fitconnect.entity.User;
import com.fitconnect.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UsuarioService {

    private final UserRepository userRepository;

    public UsuarioResponse getMiPerfil(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));
        return UsuarioResponse.from(user);
    }

    public List<UsuarioResponse> getClientesDelEntrenador(String email) {
        User entrenador = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        if (entrenador.getRol() != User.Rol.entrenador) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Solo los entrenadores pueden acceder a esta ruta");
        }

        return userRepository.findClientesByEntrenadorId(entrenador.getId())
                .stream()
                .map(UsuarioResponse::from)
                .toList();
    }
}