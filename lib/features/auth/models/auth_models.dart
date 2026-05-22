class AuthResponse {
  final String token;
  final String email;
  final String nombre;
  final String rol;
  final int id;

  AuthResponse({
    required this.token,
    required this.email,
    required this.nombre,
    required this.rol,
    required this.id,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    token: json['token'],
    email: json['email'],
    nombre: json['nombre'],
    rol: json['rol'],
    id: json['id'],
  );
}
