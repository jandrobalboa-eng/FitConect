import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../models/auth_models.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final AuthResponse? user;

  const AuthState({this.isLoading = false, this.error, this.user});

  AuthState copyWith({bool? isLoading, String? error, AuthResponse? user}) =>
      AuthState(
        isLoading: isLoading ?? this.isLoading,
        error: error,
        user: user ?? this.user,
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Dio _dio = DioClient.getInstance();

  AuthNotifier() : super(const AuthState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _dio.post(
        '/api/auth/login',
        data: {'email': email, 'password': password},
      );
      final user = AuthResponse.fromJson(res.data['data']);
      await SecureStorage.saveToken(user.token);
      await SecureStorage.saveUserData(
        id: user.id,
        rol: user.rol,
        nombre: user.nombre,
      );
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? 'Error de conexión';
      state = state.copyWith(isLoading: false, error: msg);
      return false;
    }
  }

  Future<bool> register(String nombre, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _dio.post(
        '/api/auth/register',
        data: {
          'nombre': nombre,
          'email': email,
          'password': password,
          'rol': 'cliente',
        },
      );
      final user = AuthResponse.fromJson(res.data['data']);
      await SecureStorage.saveToken(user.token);
      await SecureStorage.saveUserData(
        id: user.id,
        rol: user.rol,
        nombre: user.nombre,
      );
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? 'Error de conexión';
      state = state.copyWith(isLoading: false, error: msg);
      return false;
    }
  }

  Future<void> logout() async {
    await SecureStorage.clearAll();
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
