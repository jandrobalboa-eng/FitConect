import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../models/perfil_model.dart';

final perfilProvider = FutureProvider<PerfilModel>((ref) async {
  final dio = DioClient.getInstance();
  try {
    final res = await dio.get('/api/usuarios/me');
    return PerfilModel.fromJson(res.data['data']);
  } on DioException catch (e) {
    throw e.response?.data['message'] ?? 'Error al cargar el perfil';
  }
});