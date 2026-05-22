import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cliente_model.dart';

class ClientesEntrenadorNotifier
    extends StateNotifier<List<ClienteEntrenador>> {
  ClientesEntrenadorNotifier() : super([]) {
    _cargar();
  }

  Future<void> _cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('clientes_entrenador') ?? [];
    state = data.map((e) => ClienteEntrenador.fromJson(jsonDecode(e))).toList();
  }

  Future<void> _guardarTodo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'clientes_entrenador',
      state.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  Future<void> agregar(ClienteEntrenador cliente) async {
    state = [...state, cliente];
    await _guardarTodo();
  }

  Future<void> actualizar(ClienteEntrenador cliente) async {
    state = state.map((c) => c.id == cliente.id ? cliente : c).toList();
    await _guardarTodo();
  }

  Future<void> eliminar(String id) async {
    state = state.where((c) => c.id != id).toList();
    await _guardarTodo();
  }
}

final clientesEntrenadorProvider =
    StateNotifierProvider<ClientesEntrenadorNotifier, List<ClienteEntrenador>>(
      (ref) => ClientesEntrenadorNotifier(),
    );
