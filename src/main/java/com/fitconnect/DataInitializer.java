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
        // Limpiar gifUrls inválidas de arranques anteriores
        ejercicioRepository.findAll().stream()
                .filter(e -> e.getGifUrl() != null)
                .forEach(e -> { e.setGifUrl(null); ejercicioRepository.save(e); });

        if (ejercicioRepository.count() > 0) return;

        List<Ejercicio> ejercicios = List.of(
            // ─── PECHO ───────────────────────────────────────────────────────────
            ej("Press de banca con barra",
               "Tumbado en el banco, baja la barra hasta el pecho y empuja hacia arriba. Mantén los pies apoyados en el suelo y los omóplatos retraídos.",
               "Pecho"),
            ej("Press inclinado con mancuernas",
               "Banco inclinado a 30-45°. Empuja las mancuernas desde la altura del pecho hacia arriba y ligeramente hacia el centro.",
               "Pecho"),
            ej("Aperturas con mancuernas",
               "Tumbado en banco plano, con los brazos ligeramente flexionados abre los brazos en arco amplio hasta sentir el estiramiento del pecho.",
               "Pecho"),
            ej("Fondos en paralelas",
               "Apoya el cuerpo en las barras paralelas, inclínate ligeramente hacia delante y baja hasta que los codos formen 90°, luego sube.",
               "Pecho"),
            ej("Press en máquina de pecho",
               "Siéntate en la máquina y empuja los mangos hacia delante hasta extensión completa. Controla el regreso.",
               "Pecho"),

            // ─── ESPALDA ─────────────────────────────────────────────────────────
            ej("Dominadas",
               "Cuelga de la barra con agarre prono, tira hacia arriba hasta que la barbilla supere la barra. Baja de forma controlada.",
               "Espalda"),
            ej("Remo con barra",
               "Inclinado hacia delante con la espalda recta, tira de la barra hacia el abdomen. Retrae los omóplatos al final del movimiento.",
               "Espalda"),
            ej("Jalón al pecho en polea",
               "Sentado en la máquina de polea, tira de la barra hacia el pecho manteniendo el torso ligeramente inclinado y los codos hacia abajo.",
               "Espalda"),
            ej("Remo con mancuerna",
               "Apoya una rodilla y una mano en el banco. Con la otra mano tira de la mancuerna hacia la cadera, llevando el codo hacia atrás.",
               "Espalda"),
            ej("Peso muerto",
               "Con la barra en el suelo, agárrala con los pies a la anchura de los hombros. Sube manteniendo la espalda recta hasta quedar erguido.",
               "Espalda"),

            // ─── HOMBROS ─────────────────────────────────────────────────────────
            ej("Press militar con barra",
               "De pie o sentado, empuja la barra desde los hombros hasta la extensión completa sobre la cabeza. Mantén el core activo.",
               "Hombros"),
            ej("Elevaciones laterales con mancuernas",
               "Con los brazos a los lados, eleva las mancuernas en arco lateral hasta la altura de los hombros. Mantén una leve flexión en los codos.",
               "Hombros"),
            ej("Pájaros con mancuernas",
               "Inclinado hacia delante, eleva las mancuernas lateralmente con los codos ligeramente flexionados hasta la altura de los hombros.",
               "Hombros"),
            ej("Face pull en polea",
               "Con la cuerda en polea alta, tira hacia la cara separando las manos al final. Trabaja el deltoides posterior y manguito rotador.",
               "Hombros"),

            // ─── BÍCEPS ──────────────────────────────────────────────────────────
            ej("Curl de bíceps con barra",
               "De pie con la barra en supinación, flexiona los codos llevando la barra hasta los hombros. Baja de forma controlada.",
               "Bíceps"),
            ej("Curl alternado con mancuernas",
               "De pie, alterna el curl de cada brazo con la muñeca en supinación al subir. Controla el descenso.",
               "Bíceps"),
            ej("Curl martillo",
               "Agarre neutro (pulgares arriba), sube la mancuerna sin girar la muñeca. Trabaja el braquial y braquiorradial.",
               "Bíceps"),
            ej("Curl en polea baja",
               "De pie frente a la polea baja, tira del cable hacia los hombros con tensión constante a lo largo de todo el recorrido.",
               "Bíceps"),

            // ─── TRÍCEPS ─────────────────────────────────────────────────────────
            ej("Press francés con barra Z",
               "Tumbado en banco, baja la barra hacia la frente flexionando solo los codos y extiende de vuelta. Codos fijos en vertical.",
               "Tríceps"),
            ej("Extensión de tríceps en polea alta",
               "De pie frente a la polea alta, empuja el cable hacia abajo hasta la extensión completa. Codos pegados al cuerpo.",
               "Tríceps"),
            ej("Fondos de tríceps en banco",
               "Con las manos en el borde del banco y los pies al frente, baja el cuerpo flexionando los codos y sube.",
               "Tríceps"),

            // ─── PIERNAS ─────────────────────────────────────────────────────────
            ej("Sentadilla con barra",
               "Barra sobre los trapecios, pies a la anchura de los hombros. Baja como si fueras a sentarte hasta que los muslos queden paralelos al suelo.",
               "Cuádriceps"),
            ej("Prensa de piernas",
               "Siéntate en la máquina, pies a la anchura de los hombros. Empuja la plataforma hasta extensión casi completa y baja controlado.",
               "Cuádriceps"),
            ej("Zancadas con mancuernas",
               "Da un paso largo hacia delante y baja la rodilla trasera casi hasta el suelo. Alterna piernas o realiza todos los pasos con una pierna.",
               "Cuádriceps"),
            ej("Extensión de cuádriceps en máquina",
               "Sentado en la máquina, extiende las piernas hasta la posición recta y baja de forma controlada.",
               "Cuádriceps"),
            ej("Curl femoral tumbado",
               "Boca abajo en la máquina, flexiona las rodillas llevando los talones hacia los glúteos y baja controlado.",
               "Isquiotibiales"),
            ej("Peso muerto rumano",
               "De pie con la barra, baja inclinando el torso hacia delante con las rodillas ligeramente flexionadas hasta sentir el estiramiento isquiotibial.",
               "Isquiotibiales"),

            // ─── GLÚTEOS ─────────────────────────────────────────────────────────
            ej("Hip thrust con barra",
               "Con los hombros apoyados en un banco y la barra sobre las caderas, eleva las caderas hasta la extensión completa contrayendo los glúteos.",
               "Glúteos"),
            ej("Patada de glúteo en polea",
               "Con el tobillo atado a la polea baja, empuja la pierna hacia atrás manteniendo el torso estable. Contrae el glúteo al final.",
               "Glúteos"),

            // ─── CORE ────────────────────────────────────────────────────────────
            ej("Plancha abdominal",
               "Apoya los antebrazos y los pies. Mantén el cuerpo en línea recta activando el abdomen y sin dejar caer las caderas.",
               "Core"),
            ej("Crunch abdominal",
               "Tumbado boca arriba, manos detrás de la cabeza, eleva los hombros del suelo contrayendo el abdomen. No tires del cuello.",
               "Core"),
            ej("Elevación de piernas",
               "Tumbado boca arriba, eleva las piernas juntas hasta 90° manteniendo la zona lumbar pegada al suelo. Baja controlado.",
               "Core"),
            ej("Russian twist",
               "Sentado con el torso inclinado, gira el torso de lado a lado. Se puede añadir peso para mayor intensidad.",
               "Core"),

            // ─── CARDIO / FUNCIONAL ──────────────────────────────────────────────
            ej("Burpees",
               "De pie, baja al suelo, realiza una flexión, salta de vuelta a posición de pie y salta con los brazos arriba. Ejercicio de cuerpo completo.",
               "Cardio"),
            ej("Mountain climbers",
               "En posición de plancha, alterna llevando las rodillas hacia el pecho lo más rápido posible manteniendo el core activo.",
               "Cardio"),
            ej("Salto a la comba",
               "Salta continuamente con la comba manteniendo los codos pegados al cuerpo y girando solo con las muñecas.",
               "Cardio")
        );

        ejercicioRepository.saveAll(ejercicios);
    }

    private Ejercicio ej(String nombre, String descripcion, String musculo) {
        return Ejercicio.builder()
                .nombre(nombre)
                .descripcion(descripcion)
                .gifUrl(null)
                .musculoObjetivo(musculo)
                .esPredefinido(true)
                .build();
    }
}
