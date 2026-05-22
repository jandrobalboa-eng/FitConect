class SerieRealizada {
  final int numSerie;
  double? peso;
  int? reps;
  int? rir;

  SerieRealizada({required this.numSerie, this.peso, this.reps, this.rir});

  Map<String, dynamic> toJson() => {
    'numSerie': numSerie,
    'peso': peso,
    'reps': reps,
    'rir': rir,
  };

  factory SerieRealizada.fromJson(Map<String, dynamic> json) => SerieRealizada(
    numSerie: json['numSerie'],
    peso: json['peso']?.toDouble(),
    reps: json['reps'],
    rir: json['rir'],
  );
}

class EjercicioRealizado {
  final int ejercicioId;
  final String nombre;
  final List<SerieRealizada> series;

  EjercicioRealizado({
    required this.ejercicioId,
    required this.nombre,
    required this.series,
  });

  Map<String, dynamic> toJson() => {
    'ejercicioId': ejercicioId,
    'nombre': nombre,
    'series': series.map((s) => s.toJson()).toList(),
  };

  factory EjercicioRealizado.fromJson(Map<String, dynamic> json) =>
      EjercicioRealizado(
        ejercicioId: json['ejercicioId'],
        nombre: json['nombre'],
        series: (json['series'] as List)
            .map((s) => SerieRealizada.fromJson(s))
            .toList(),
      );
}

class EntrenamientoRealizado {
  final int rutinaId;
  final String fecha;
  final List<EjercicioRealizado> ejercicios;

  EntrenamientoRealizado({
    required this.rutinaId,
    required this.fecha,
    required this.ejercicios,
  });

  Map<String, dynamic> toJson() => {
    'rutinaId': rutinaId,
    'fecha': fecha,
    'ejercicios': ejercicios.map((e) => e.toJson()).toList(),
  };

  factory EntrenamientoRealizado.fromJson(Map<String, dynamic> json) =>
      EntrenamientoRealizado(
        rutinaId: json['rutinaId'],
        fecha: json['fecha'],
        ejercicios: (json['ejercicios'] as List)
            .map((e) => EjercicioRealizado.fromJson(e))
            .toList(),
      );
}
