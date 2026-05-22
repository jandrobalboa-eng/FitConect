class PerfilModel {
  final int id;
  final String email;
  final String nombre;
  final String rol;
  final String? objetivo;
  final double? altura;

  PerfilModel({
    required this.id,
    required this.email,
    required this.nombre,
    required this.rol,
    this.objetivo,
    this.altura,
  });

  factory PerfilModel.fromJson(Map<String, dynamic> json) => PerfilModel(
    id: json['id'],
    email: json['email'],
    nombre: json['nombre'],
    rol: json['rol'],
    objetivo: json['objetivo'],
    altura: json['altura']?.toDouble(),
  );
}
