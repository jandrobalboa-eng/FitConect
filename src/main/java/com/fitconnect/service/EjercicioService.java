package com.fitconnect.service;

import com.fitconnect.dto.response.EjercicioResponse;
import com.fitconnect.entity.Ejercicio;
import com.fitconnect.entity.User;
import com.fitconnect.repository.EjercicioRepository;
import com.fitconnect.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class EjercicioService {

    private final EjercicioRepository ejercicioRepository;
    private final UserRepository userRepository;

    public List<EjercicioResponse> getCatalogo(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));

        List<Ejercicio> ejercicios = user.getRol() == User.Rol.entrenador
                ? ejercicioRepository.findCatalogoParaEntrenador(user.getId())
                : ejercicioRepository.findByEsPredefinidoTrue();

        return ejercicios.stream()
                .map(EjercicioResponse::from)
                .toList();
    }
}