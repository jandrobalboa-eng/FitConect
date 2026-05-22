import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/rutinas_entrenador_provider.dart';
import '../models/rutina_entrenador_model.dart';
import 'crear_rutina_screen.dart';
import 'detalle_rutina_entrenador_screen.dart';

class RutinasEntrenadorScreen extends ConsumerWidget {
  const RutinasEntrenadorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rutinas = ref.watch(rutinasEntrenadorProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Rutinas asignadas',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CrearRutinaScreen()),
        ),
        backgroundColor: const Color(0xFF6C63FF),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Crear rutina',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: rutinas.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fitness_center, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay rutinas creadas aún',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: rutinas.length,
              itemBuilder: (context, index) {
                final rutina = rutinas[index];
                return _RutinaCard(rutina: rutina, index: index);
              },
            ),
    );
  }
}

class _RutinaCard extends ConsumerWidget {
  final RutinaEntrenador rutina;
  final int index;

  const _RutinaCard({required this.rutina, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetalleRutinaEntrenadorScreen(rutina: rutina),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.fitness_center, color: Color(0xFF6C63FF)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rutina.nombreCompleto,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${rutina.diasPorSemana} días/semana · ${rutina.semanas.length} semanas',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    rutina.clienteNombre,
                    style: const TextStyle(
                      color: Color(0xFF6C63FF),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () async {
                final confirmar = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: const Color(0xFF1E1E1E),
                    title: const Text(
                      'Borrar rutina',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text(
                      '¿Seguro que quieres borrar esta rutina?',
                      style: TextStyle(color: Colors.grey),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          'Borrar',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirmar == true) {
                  await ref
                      .read(rutinasEntrenadorProvider.notifier)
                      .eliminar(rutina.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
