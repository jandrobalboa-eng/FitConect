package com.fitconnect.service;

import com.resend.Resend;
import com.resend.core.exception.ResendException;
import com.resend.services.emails.model.CreateEmailOptions;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class EmailService {

    @Value("${resend.api.key:}")
    private String apiKey;

    public void enviarBienvenida(String emailDestino, String nombre, String rol) {
        if (apiKey == null || apiKey.isBlank()) {
            log.warn("RESEND_API_KEY no configurada, email omitido");
            return;
        }

        String emoji = rol.equals("entrenador") ? "💪" : "🏃";
        String rolTexto = rol.equals("entrenador") ? "entrenador" : "cliente";

        String html = """
            <div style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;background:#0f0f0f;color:#fff;border-radius:12px;overflow:hidden">
              <div style="background:#22c55e;padding:32px;text-align:center">
                <h1 style="margin:0;font-size:32px">FitConnect %s</h1>
                <p style="margin:8px 0 0;opacity:0.9">Tu plataforma de entrenamiento personal</p>
              </div>
              <div style="padding:32px">
                <h2 style="color:#22c55e">¡Bienvenido/a, %s!</h2>
                <p style="color:#ccc;line-height:1.6">
                  Tu cuenta de <strong style="color:#fff">%s</strong> ha sido creada correctamente.
                  Ya puedes acceder a la plataforma y empezar.
                </p>
                <div style="background:#1a1a1a;border-radius:8px;padding:20px;margin:24px 0;border-left:4px solid #22c55e">
                  <p style="margin:0;color:#ccc">Accede con tu email: <strong style="color:#fff">%s</strong></p>
                </div>
                <a href="https://fit-conect.vercel.app"
                   style="display:inline-block;background:#22c55e;color:#000;padding:14px 32px;border-radius:8px;text-decoration:none;font-weight:bold;margin-top:8px">
                  Entrar a FitConnect
                </a>
              </div>
              <div style="padding:20px 32px;background:#0a0a0a;text-align:center">
                <p style="color:#666;font-size:12px;margin:0">FitConnect · IES Augustóbriga · DAM 2025</p>
              </div>
            </div>
            """.formatted(emoji, nombre, rolTexto, emailDestino);

        try {
            Resend resend = new Resend(apiKey);
            CreateEmailOptions params = CreateEmailOptions.builder()
                    .from("FitConnect <onboarding@resend.dev>")
                    .to(emailDestino)
                    .subject("¡Bienvenido/a a FitConnect " + emoji + "!")
                    .html(html)
                    .build();

            resend.emails().send(params);
            log.info("Email de bienvenida enviado a {}", emailDestino);

        } catch (ResendException e) {
            log.error("Error enviando email a {}: {}", emailDestino, e.getMessage());
        }
    }
}