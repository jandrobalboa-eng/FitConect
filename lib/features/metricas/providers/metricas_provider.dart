import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../models/metrica_model.dart';

final metricasProvider = FutureProvider<List<MetricaModel>>((ref) async {
  final dio = DioClient.getInstance();
  try {
    final res = await dio.get('/api/metricas/mis-metricas');
    return (res.data['data'] as List)
        .map((e) => MetricaModel.fromJson(e))
        .toList();
  } on DioException catch (e) {
    throw e.response?.data['message'] ?? 'Error al cargar las métricas';
  }
});

class MetricasNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio _dio = DioClient.getInstance();

  MetricasNotifier() : super(const AsyncValue.data(null));

  Future<bool> registrarMetrica({
    required String fecha,
    double? peso,
    double? medidaCintura,
    double? medidaCadera,
    String? notas,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _dio.post(
        '/api/metricas',
        data: {
          'fecha': fecha,
          'peso': ?peso,
          'medidaCintura': ?medidaCintura,
          'medidaCadera': ?medidaCadera,
          'notas': ?notas,
        },
      );
      state = const AsyncValue.data(null);
      return true;
    } on DioException catch (e) {
      state = AsyncValue.error(
        e.response?.data['message'] ?? 'Error al registrar',
        StackTrace.current,
      );
      return false;
    }
  }
}

final metricasNotifierProvider =
    StateNotifierProvider<MetricasNotifier, AsyncValue<void>>(
      (ref) => MetricasNotifier(),
    );
