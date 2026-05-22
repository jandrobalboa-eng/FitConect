import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../models/rutina_model.dart';

final rutinasProvider = FutureProvider<List<RutinaModel>>((ref) async {
  final dio = DioClient.getInstance();
  try {
    final res = await dio.get('/api/rutinas/mis-rutinas');
    return (res.data['data'] as List)
        .map((e) => RutinaModel.fromJson(e))
        .toList();
  } on DioException catch (e) {
    throw e.response?.data['message'] ?? 'Error al cargar las rutinas';
  }
});
