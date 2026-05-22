package com.fitconnect;

import com.fitconnect.entity.Ejercicio;
import com.fitconnect.repository.EjercicioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final EjercicioRepository ejercicioRepository;

    @Override
    public void run(String... args) {
        if (ejercicioRepository.count() > 0) return;

        List<Ejercicio> ejercicios = List.of(
            // ─── PECHO ───────────────────────────────────────────────────────────
            ej("Press de banca con barra",
               "Tumbado en el banco, baja la barra hasta el pecho y empuja hacia arriba. Mantén los pies apoyados en el suelo y los omóplatos retraídos.",
               "https://v2.exercisedb.io/image/XdBHOFf8r0vhQJ",
               "Pecho"),
            ej("Press inclinado con mancuernas",
               "Banco inclinado a 30-45°. Empuja las mancuernas desde la altura del pecho hacia arriba y ligeramente hacia el centro.",
               "https://v2.exercisedb.io/image/QNbfyDCO3LZJG0",
               "Pecho"),
            ej("Aperturas con mancuernas",
               "Tumbado en banco plano, con los brazos ligeramente flexionados abre los brazos en arco amplio hasta sentir el estiramiento del pecho.",
               "https://v2.exercisedb.io/image/BNxmCdCkFX1ggc",
               "Pecho"),
            ej("Fondos en paralelas",
               "Apoya el cuerpo en las barras paralelas, inclínate ligeramente hacia delante y baja hasta que los codos formen 90°, luego sube.",
               null,
               "Pecho"),
            ej("Press en máquina de pecho",
               "Siéntate en la máquina y empuja los mangos hacia delante hasta extensión completa. Controla el regreso.",
               null,
               "Pecho"),

            // ─── ESPALDA ─────────────────────────────────────────────────────────
            ej("Dominadas",
               "Cuelga de la barra con agarre prono, tira hacia arriba hasta que la barbilla supere la barra. Baja de forma controlada.",
               "https://v2.exercisedb.io/image/R2mE0osN3WFXN5",
               "Espalda"),
            ej("Remo con barra",
               "Inclinado hacia delante con la espalda recta, tira de la barra hacia el abdomen. Retrae los omóplatos al final del movimiento.",
               "https://v2.exercisedb.io/image/ZEnJTBPjJ6bN6j",
               "Espalda"),
            ej("Jalón al pecho en polea",
               "Sentado en la máquina de polea, tira de la barra hacia el pecho manteniendo el torso ligeramente inclinado y los codos hacia abajo.",
               "https://v2.exercisedb.io/image/I3wG7YuaqHBZq0",
               "Espalda"),
            ej("Remo con mancuerna",
               "Apoya una rodilla y una mano en el banco. Con la otra mano tira de la mancuerna hacia la cadera, llevando el codo hacia atrás.",
               null,
               "Espalda"),
            ej("Peso muerto",
               "Con la barra en el suelo, agárrala con los pies a la anchura de los hombros. Sube manteniendo la espalda recta hasta quedar erguido.",
               "https://v2.exercisedb.io/image/9vBb3Y6QaigNXe",
               "Espalda"),

            // ─── HOMBROS ─────────────────────────────────────────────────────────
            ej("Press militar con barra",
               "De pie o sentado, empuja la barra desde los hombros hasta la extensión completa sobre la cabeza. Mantén el core activo.",
               "https://v2.exercisedb.io/image/Bk3WIo5sW47k5z",
               "Hombros"),
            ej("Elevaciones laterales con mancuernas",
               "Con los brazos a los lados, eleva las mancuernas en arco lateral hasta la altura de los hombros. Mantén una leve flexión en los codos.",
               "https://v2.exercisedb.io/image/0JEsKFBiMtJvIj",
               "Hombros"),
            ej("Pájaros con mancuernas",
               "Inclinado hacia delante, eleva las mancuernas lateralmente con los codos ligeramente flexionados hasta la altura de los hombros.",
               null,
               "Hombros"),
            ej("Face pull en polea",
               "Con la cuerda en polea alta, tira hacia la cara separando las manos al final. Trabaja el deltoides posterior y manguito rotador.",
               null,
               "Hombros"),

            // ─── BÍCEPS ──────────────────────────────────────────────────────────
            ej("Curl de bíceps con barra",
               "De pie con la barra en supinación, flexiona los codos llevando la barra hasta los hombros. Baja de forma controlada.",
               "https://v2.exercisedb.io/image/kXiWlY2YO8cpyU",
               "Bíceps"),
            ej("Curl alternado con mancuernas",
               "De pie, alterna el curl de cada brazo con la muñeca en supinación al subir. Controla el descenso.",
               "https://v2.exercisedb.io/image/VmkHmAVtjKFHuK",
               "Bíceps"),
            ej("Curl martillo",
               "Agarre neutro (pulgares arriba), sube la mancuerna sin girar la muñeca. Trabaja el braquial y braquiorradial.",
               null,
               "Bíceps"),
            ej("Curl en polea baja",
               "De pie frente a la polea baja, tira del cable hacia los hombros con tensión constante a lo largo de todo el recorrido.",
               null,
               "Bíceps"),

            // ─── TRÍCEPS ─────────────────────────────────────────────────────────
            ej("Press francés con barra Z",
               "Tumbado en banco, baja la barra hacia la frente flexionando solo los codos y extiende de vuelta. Codos fijos en vertical.",
               "https://v2.exercisedb.io/image/SQ-dIFZsFqNvxz",
               "Tríceps"),
            ej("Extensión de tríceps en polea alta",
               "De pie frente a la polea alta, empuja el cable hacia abajo hasta la extensión completa. Codos pegados al cuerpo.",
               "https://v2.exercisedb.io/image/wCGGBSWCGfOqO5",
               "Tríceps"),
            ej("Fondos de tríceps en banco",
               "Con las manos en el borde del banco y los pies al frente, baja el cuerpo flexionando los codos y sube.",
               null,
               "Tríceps"),

            // ─── PIERNAS ─────────────────────────────────────────────────────────
            ej("Sentadilla con barra",
               "Barra sobre los trapecios, pies a la anchura de los hombros. Baja como si fueras a sentarte hasta que los muslos queden paralelos al suelo.",
               "https://v2.exercisedb.io/image/pJiWCpqr4tF1p8",
               "Cuádriceps"),
            ej("Prensa de piernas",
               "Siéntate en la máquina, pies a la anchura de los hombros. Empuja la plataforma hasta extensión casi completa y baja controlado.",
               "https://v2.exercisedb.io/image/kFjO4dkv1BtQKB",
               "Cuádriceps"),
            ej("Zancadas con mancuernas",
               "Da un paso largo hacia delante y baja la rodilla trasera casi hasta el suelo. Alterna piernas o realiza todos los pasos con una pierna.",
               "https://v2.exercisedb.io/image/XSx3H4rqCO9FEN",
               "Cuádriceps"),
            ej("Extensión de cuádriceps en máquina",
               "Sentado en la máquina, extiende las piernas hasta la posición recta y baja de forma controlada.",
               null,
               "Cuádriceps"),
            ej("Curl femoral tumbado",
               "Boca abajo en la máquina, flexiona las rodillas llevando los talones hacia los glúteos y baja controlado.",
               "https://v2.exercisedb.io/image/1Y1yE-mFmvthHO",
               "Isquiotibiales"),
            ej("Peso muerto rumano",
               "De pie con la barra, baja inclinando el torso hacia delante con las rodillas ligeramente flexionadas hasta sentir el estiramiento isquiotibial.",
               "https://v2.exercisedb.io/image/hYYpj8jJBH5GHI",
               "Isquiotibiales"),

            // ─── GLÚTEOS ─────────────────────────────────────────────────────────
            ej("Hip thrust con barra",
               "Con los hombros apoyados en un banco y la barra sobre las caderas, eleva las caderas hasta la extensión completa contrayendo los glúteos.",
               "https://v2.exercisedb.io/image/ZOFOJFYkDI3qTX",
               "Glúteos"),
            ej("Patada de glúteo en polea",
               "Con el tobillo atado a la polea baja, empuja la pierna hacia atrás manteniendo el torso estable. Contrae el glúteo al final.",
               null,
               "Glúteos"),

            // ─── CORE ────────────────────────────────────────────────────────────
            ej("Plancha abdominal",
               "Apoya los antebrazos y los pies. Mantén el cuerpo en línea recta activando el abdomen y sin dejar caer las caderas.",
               "https://v2.exercisedb.io/image/v-FDCM0JbYB6u8",
               "Core"),
            ej("Crunch abdominal",
               "Tumbado boca arriba, manos detrás de la cabeza, eleva los hombros del suelo contrayendo el abdomen. No tires del cuello.",
               "https://v2.exercisedb.io/image/7B5RGAhQI4VhiM",
               "Core"),
            ej("Elevación de piernas",
               "Tumbado boca arriba, eleva las piernas juntas hasta 90° manteniendo la zona lumbar pegada al suelo. Baja controlado.",
               null,
               "Core"),
            ej("Russian twist",
               "Sentado con el torso inclinado, gira el torso de lado a lado. Se puede añadir peso para mayor intensidad.",
               null,
               "Core"),

            // ─── CARDIO / FUNCIONAL ───────────────────────────────────────────────
            ej("Burpees",
               "De pie, baja al suelo, realiza una flexión, salta de vuelta a posición de pie y salta con los brazos arriba. Ejercicio de cuerpo completo.",
               null,
               "Cardio"),
            ej("Mountain climbers",
               "En posición de plancha, alterna llevando las rodillas hacia el pecho lo más rápido posible manteniendo el core activo.",
               "https://v2.exercisedb.io/image/BoZXuFbXZl6VFC",
               "Cardio"),
            ej("Salto a la comba",
               "Salta continuamente con la comba manteniendo los codos pegados al cuerpo y girando solo con las muñecas.",
               null,
               "Cardio")
        );

        ejercicioRepository.saveAll(ejercicios);
    }

    private Ejercicio ej(String nombre, String descripcion, String gifUrl, String musculo) {
        return Ejercicio.builder()
                .nombre(nombre)
                .descripcion(descripcion)
                .gifUrl(gifUrl)
                .musculoObjetivo(musculo)
                .esPredefinido(true)
                .build();
    }
}
