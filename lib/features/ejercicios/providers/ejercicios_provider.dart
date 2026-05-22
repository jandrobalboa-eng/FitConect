import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../models/ejercicio_model.dart';

final ejerciciosProvider = FutureProvider<List<EjercicioModel>>((ref) async {
  final dio = DioClient.getInstance();
  try {
    final res = await dio.get('/api/ejercicios');
    return (res.data['data'] as List)
        .map((e) => EjercicioModel.fromJson(e))
        .toList();
  } on DioException catch (e) {
    throw e.response?.data['message'] ?? 'Error al cargar los ejercicios';
  }
});
