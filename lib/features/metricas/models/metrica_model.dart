class MetricaModel {
  final int id;
  final String fecha;
  final double? peso;
  final double? medidaCintura;
  final double? medidaCadera;
  final String? notas;

  MetricaModel({
    required this.id,
    required this.fecha,
    this.peso,
    this.medidaCintura,
    this.medidaCadera,
    this.notas,
  });

  factory MetricaModel.fromJson(Map<String, dynamic> json) => MetricaModel(
    id: json['id'],
    fecha: json['fecha'],
    peso: json['peso']?.toDouble(),
    medidaCintura: json['medidaCintura']?.toDouble(),
    medidaCadera: json['medidaCadera']?.toDouble(),
    notas: json['notas'],
  );
}
