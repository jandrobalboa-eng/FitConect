import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ejercicios_provider.dart';
import '../models/ejercicio_model.dart';
import '../../../shared/widgets/error_widget.dart';

class EjerciciosScreen extends ConsumerWidget {
  const EjerciciosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ejerciciosAsync = ref.watch(ejerciciosProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Ejercicios', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref.invalidate(ejerciciosProvider),
          ),
        ],
      ),
      body: ejerciciosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          mensaje: e.toString(),
          onRetry: () => ref.invalidate(ejerciciosProvider),
        ),
        data: (ejercicios) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: ejercicios.length,
          itemBuilder: (context, index) {
            final ejercicio = ejercicios[index];
            return _EjercicioCard(ejercicio: ejercicio);
          },
        ),
      ),
    );
  }
}

class _EjercicioCard extends StatelessWidget {
  final EjercicioModel ejercicio;

  const _EjercicioCard({required this.ejercicio});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ejercicio.gifUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      ejercicio.gifUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.fitness_center,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                  )
                : const Icon(Icons.fitness_center, color: Color(0xFF6C63FF)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ejercicio.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (ejercicio.musculoObjetivo != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    ejercicio.musculoObjetivo!,
                    style: const TextStyle(
                      color: Color(0xFF6C63FF),
                      fontSize: 13,
                    ),
                  ),
                ],
                if (ejercicio.descripcion != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    ejercicio.descripcion!,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
