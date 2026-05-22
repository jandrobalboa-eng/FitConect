import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/entrenamiento_model.dart';

class EntrenamientoNotifier
    extends StateNotifier<List<EntrenamientoRealizado>> {
  EntrenamientoNotifier() : super([]) {
    _cargar();
  }

  Future<void> _cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('entrenamientos') ?? [];
    state = data
        .map((e) => EntrenamientoRealizado.fromJson(jsonDecode(e)))
        .toList();
  }

  Future<void> guardar(EntrenamientoRealizado entrenamiento) async {
    final prefs = await SharedPreferences.getInstance();
    final nuevos = [...state, entrenamiento];
    await prefs.setStringList(
      'entrenamientos',
      nuevos.map((e) => jsonEncode(e.toJson())).toList(),
    );
    state = nuevos;
  }

  Future<void> editar(int index, EntrenamientoRealizado entrenamiento) async {
    final prefs = await SharedPreferences.getInstance();
    final nuevos = [...state];
    nuevos[index] = entrenamiento;
    await prefs.setStringList(
      'entrenamientos',
      nuevos.map((e) => jsonEncode(e.toJson())).toList(),
    );
    state = nuevos;
  }

  Future<void> borrar(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final nuevos = [...state]..removeAt(index);
    await prefs.setStringList(
      'entrenamientos',
      nuevos.map((e) => jsonEncode(e.toJson())).toList(),
    );
    state = nuevos;
  }

  List<EntrenamientoRealizado> getByRutina(int rutinaId) {
    return state.where((e) => e.rutinaId == rutinaId).toList();
  }
}

final entrenamientoProvider =
    StateNotifierProvider<EntrenamientoNotifier, List<EntrenamientoRealizado>>(
      (ref) => EntrenamientoNotifier(),
    );
