class EjercicioRutina {
  final int id;
  final String nombre;
  final String? musculoObjetivo;
  final String? gifUrl;
  final int series;
  final String repeticiones;
  final String descanso;
  final String diaSemana;

  EjercicioRutina({
    required this.id,
    required this.nombre,
    this.musculoObjetivo,
    this.gifUrl,
    required this.series,
    required this.repeticiones,
    required this.descanso,
    required this.diaSemana,
  });

  factory EjercicioRutina.fromJson(Map<String, dynamic> json) =>
      EjercicioRutina(
        id: json['id'],
        nombre: json['nombre'],
        musculoObjetivo: json['musculoObjetivo'],
        gifUrl: json['gifUrl'],
        series: json['series'],
        repeticiones: json['repeticiones'],
        descanso: json['descanso'],
        diaSemana: json['diaSemana'],
      );
}

class RutinaModel {
  final int id;
  final String nombre;
  final String? descripcion;
  final String fechaAsignacion;
  final String entrenadorNombre;
  final List<EjercicioRutina> ejercicios;

  RutinaModel({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.fechaAsignacion,
    required this.entrenadorNombre,
    required this.ejercicios,
  });

  factory RutinaModel.fromJson(Map<String, dynamic> json) => RutinaModel(
    id: json['id'],
    nombre: json['nombre'],
    descripcion: json['descripcion'],
    fechaAsignacion: json['fechaAsignacion'],
    entrenadorNombre: json['entrenadorNombre'],
    ejercicios: (json['ejercicios'] as List)
        .map((e) => EjercicioRutina.fromJson(e))
        .toList(),
  );
}
