class SerieEntrenador {
  String peso;
  String reps;
  String rir;
  String notas;

  SerieEntrenador({
    this.peso = '',
    this.reps = '',
    this.rir = '',
    this.notas = '',
  });

  Map<String, dynamic> toJson() => {
    'peso': peso,
    'reps': reps,
    'rir': rir,
    'notas': notas,
  };

  factory SerieEntrenador.fromJson(Map<String, dynamic> json) =>
      SerieEntrenador(
        peso: json['peso'] ?? '',
        reps: json['reps'] ?? '',
        rir: json['rir'] ?? '',
        notas: json['notas'] ?? '',
      );
}

class EjercicioEntrenador {
  String nombre;
  String descanso;
  List<SerieEntrenador> series;

  EjercicioEntrenador({
    this.nombre = '',
    this.descanso = '60s',
    List<SerieEntrenador>? series,
  }) : series = series ?? [SerieEntrenador()];

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'descanso': descanso,
    'series': series.map((s) => s.toJson()).toList(),
  };

  factory EjercicioEntrenador.fromJson(Map<String, dynamic> json) =>
      EjercicioEntrenador(
        nombre: json['nombre'] ?? '',
        descanso: json['descanso'] ?? '60s',
        series: (json['series'] as List)
            .map((s) => SerieEntrenador.fromJson(s))
            .toList(),
      );
}

class DiaEntrenador {
  String nombre;
  String fechaRealizacion;
  List<EjercicioEntrenador> ejercicios;

  DiaEntrenador({
    required this.nombre,
    this.fechaRealizacion = '',
    List<EjercicioEntrenador>? ejercicios,
  }) : ejercicios = ejercicios ?? [];

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'fechaRealizacion': fechaRealizacion,
    'ejercicios': ejercicios.map((e) => e.toJson()).toList(),
  };

  factory DiaEntrenador.fromJson(Map<String, dynamic> json) => DiaEntrenador(
    nombre: json['nombre'] ?? '',
    fechaRealizacion: json['fechaRealizacion'] ?? '',
    ejercicios: (json['ejercicios'] as List)
        .map((e) => EjercicioEntrenador.fromJson(e))
        .toList(),
  );
}

class SemanaEntrenador {
  int numero;
  List<DiaEntrenador> dias;

  SemanaEntrenador({required this.numero, required this.dias});

  Map<String, dynamic> toJson() => {
    'numero': numero,
    'dias': dias.map((d) => d.toJson()).toList(),
  };

  factory SemanaEntrenador.fromJson(Map<String, dynamic> json) =>
      SemanaEntrenador(
        numero: json['numero'],
        dias: (json['dias'] as List)
            .map((d) => DiaEntrenador.fromJson(d))
            .toList(),
      );
}

class RutinaEntrenador {
  String id;
  String clienteNombre;
  String clienteEmail;
  String tipo;
  String dia;
  String mes;
  String anio;
  String fechaInicio;
  int diasPorSemana;
  List<String> nombreDias;
  List<SemanaEntrenador> semanas;

  RutinaEntrenador({
    required this.id,
    required this.clienteNombre,
    required this.clienteEmail,
    required this.tipo,
    required this.dia,
    required this.mes,
    required this.anio,
    required this.fechaInicio,
    required this.diasPorSemana,
    required this.nombreDias,
    required this.semanas,
  });

  String get nombreCompleto => '$tipo — $clienteNombre — $dia/$mes/$anio';

  Map<String, dynamic> toJson() => {
    'id': id,
    'clienteNombre': clienteNombre,
    'clienteEmail': clienteEmail,
    'tipo': tipo,
    'dia': dia,
    'mes': mes,
    'anio': anio,
    'fechaInicio': fechaInicio,
    'diasPorSemana': diasPorSemana,
    'nombreDias': nombreDias,
    'semanas': semanas.map((s) => s.toJson()).toList(),
  };

  factory RutinaEntrenador.fromJson(Map<String, dynamic> json) =>
      RutinaEntrenador(
        id: json['id'],
        clienteNombre: json['clienteNombre'],
        clienteEmail: json['clienteEmail'],
        tipo: json['tipo'],
        dia: json['dia'] ?? '1',
        mes: json['mes'],
        anio: json['anio'],
        fechaInicio: json['fechaInicio'] ?? '',
        diasPorSemana: json['diasPorSemana'],
        nombreDias: List<String>.from(json['nombreDias']),
        semanas: (json['semanas'] as List)
            .map((s) => SemanaEntrenador.fromJson(s))
            .toList(),
      );

  static RutinaEntrenador crear({
    required String clienteNombre,
    required String clienteEmail,
    required String tipo,
    required String dia,
    required String mes,
    required String anio,
    required String fechaInicio,
    required int diasPorSemana,
    required List<String> nombreDias,
  }) {
    final semanas = List.generate(
      4,
      (i) => SemanaEntrenador(
        numero: i + 1,
        dias: List.generate(
          diasPorSemana,
          (j) => DiaEntrenador(nombre: nombreDias[j]),
        ),
      ),
    );

    return RutinaEntrenador(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      clienteNombre: clienteNombre,
      clienteEmail: clienteEmail,
      tipo: tipo,
      dia: dia,
      mes: mes,
      anio: anio,
      fechaInicio: fechaInicio,
      diasPorSemana: diasPorSemana,
      nombreDias: nombreDias,
      semanas: semanas,
    );
  }
}
