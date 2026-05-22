import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/rutina_entrenador_model.dart';

class RutinasEntrenadorNotifier extends StateNotifier<List<RutinaEntrenador>> {
  RutinasEntrenadorNotifier() : super([]) {
    _cargar();
  }

  Future<void> _cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('rutinas_entrenador') ?? [];
    state = data.map((e) => RutinaEntrenador.fromJson(jsonDecode(e))).toList();
  }

  Future<void> _guardarTodo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'rutinas_entrenador',
      state.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  Future<void> agregar(RutinaEntrenador rutina) async {
    state = [...state, rutina];
    await _guardarTodo();
  }

  Future<void> actualizar(RutinaEntrenador rutina) async {
    state = state.map((r) => r.id == rutina.id ? rutina : r).toList();
    await _guardarTodo();
  }

  Future<void> eliminar(String id) async {
    state = state.where((r) => r.id != id).toList();
    await _guardarTodo();
  }
}

final rutinasEntrenadorProvider =
    StateNotifierProvider<RutinasEntrenadorNotifier, List<RutinaEntrenador>>(
      (ref) => RutinasEntrenadorNotifier(),
    );
