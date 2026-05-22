class ClienteEntrenador {
  String id;
  String nombre;
  String email;
  String objetivo;
  String fechaInicio;
  int mesesContratados;

  ClienteEntrenador({
    required this.id,
    required this.nombre,
    required this.email,
    required this.objetivo,
    required this.fechaInicio,
    required this.mesesContratados,
  });

  DateTime get fechaFin {
    final partes = fechaInicio.split('/');
    final inicio = DateTime(
      int.parse(partes[2]),
      int.parse(partes[1]),
      int.parse(partes[0]),
    );
    return DateTime(inicio.year, inicio.month + mesesContratados, inicio.day);
  }

  bool get estaActivo => fechaFin.isAfter(DateTime.now());

  int get diasRestantes => fechaFin.difference(DateTime.now()).inDays;

  bool get proximoAVencer => diasRestantes <= 7 && diasRestantes >= 0;

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'email': email,
    'objetivo': objetivo,
    'fechaInicio': fechaInicio,
    'mesesContratados': mesesContratados,
  };

  factory ClienteEntrenador.fromJson(Map<String, dynamic> json) =>
      ClienteEntrenador(
        id: json['id'],
        nombre: json['nombre'],
        email: json['email'],
        objetivo: json['objetivo'],
        fechaInicio: json['fechaInicio'],
        mesesContratados: json['mesesContratados'],
      );
}
