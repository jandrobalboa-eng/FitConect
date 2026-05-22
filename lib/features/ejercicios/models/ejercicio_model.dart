class EjercicioModel {
  final int id;
  final String nombre;
  final String? descripcion;
  final String? gifUrl;
  final String? musculoObjetivo;

  EjercicioModel({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.gifUrl,
    this.musculoObjetivo,
  });

  factory EjercicioModel.fromJson(Map<String, dynamic> json) => EjercicioModel(
    id: json['id'],
    nombre: json['nombre'],
    descripcion: json['descripcion'],
    gifUrl: json['gifUrl'],
    musculoObjetivo: json['musculoObjetivo'],
  );
}
