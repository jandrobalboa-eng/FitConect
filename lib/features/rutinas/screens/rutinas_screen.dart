import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/rutinas_provider.dart';
import '../providers/entrenamiento_provider.dart';
import '../models/rutina_model.dart';
import '../models/entrenamiento_model.dart';
import '../../../shared/widgets/error_widget.dart';
import 'entrenamiento_screen.dart';

class RutinasScreen extends ConsumerWidget {
  const RutinasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Rutinas', style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () => ref.invalidate(rutinasProvider),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Color(0xFF6C63FF),
            labelColor: Color(0xFF6C63FF),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Mis rutinas'),
              Tab(text: 'Historial'),
            ],
          ),
        ),
        body: const TabBarView(children: [_RutinasTab(), _HistorialTab()]),
      ),
    );
  }
}

class _RutinasTab extends ConsumerWidget {
  const _RutinasTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rutinasAsync = ref.watch(rutinasProvider);

    return rutinasAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => AppErrorWidget(
        mensaje: e.toString(),
        onRetry: () => ref.invalidate(rutinasProvider),
      ),
      data: (rutinas) => rutinas.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fitness_center, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No tienes rutinas asignadas aún',
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
                return _RutinaCard(rutina: rutina);
              },
            ),
    );
  }
}

class _HistorialTab extends ConsumerWidget {
  const _HistorialTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entrenamientos = ref.watch(entrenamientoProvider);

    if (entrenamientos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Sin entrenamientos registrados aún',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    final ordenados = [...entrenamientos]
      ..sort((a, b) => b.fecha.compareTo(a.fecha));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ordenados.length,
      itemBuilder: (context, index) {
        return _EntrenoCard(entreno: ordenados[index], index: index);
      },
    );
  }
}

class _EntrenoCard extends ConsumerWidget {
  final EntrenamientoRealizado entreno;
  final int index;

  const _EntrenoCard({required this.entreno, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(
          entreno.fecha,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${entreno.ejercicios.length} ejercicios',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF6C63FF),
          child: Icon(Icons.fitness_center, color: Colors.white, size: 20),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF6C63FF)),
              onPressed: () {
                final rutinasAsync = ref.read(rutinasProvider);
                rutinasAsync.whenData((rutinas) {
                  final rutina = rutinas.firstWhere(
                    (r) => r.id == entreno.rutinaId,
                    orElse: () => rutinas.first,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EntrenamientoScreen(
                        rutina: rutina,
                        entrenamientoExistente: entreno,
                        entrenamientoIndex: index,
                      ),
                    ),
                  );
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () async {
                final confirmar = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: const Color(0xFF1E1E1E),
                    title: const Text(
                      'Borrar entrenamiento',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text(
                      '¿Seguro que quieres borrar este entrenamiento?',
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
                  await ref.read(entrenamientoProvider.notifier).borrar(index);
                }
              },
            ),
          ],
        ),
        children: entreno.ejercicios
            .map((e) => _EjercicioHistorial(ejercicio: e))
            .toList(),
      ),
    );
  }
}

class _EjercicioHistorial extends StatelessWidget {
  final EjercicioRealizado ejercicio;

  const _EjercicioHistorial({required this.ejercicio});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ejercicio.nombre,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Serie',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF6C63FF), fontSize: 11),
                ),
              ),
              Expanded(
                child: Text(
                  'Peso',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF6C63FF), fontSize: 11),
                ),
              ),
              Expanded(
                child: Text(
                  'Reps',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF6C63FF), fontSize: 11),
                ),
              ),
              Expanded(
                child: Text(
                  'RIR',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF6C63FF), fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ...ejercicio.series.map(
            (s) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'S${s.numSerie}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      s.peso != null ? '${s.peso} kg' : '-',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      s.reps != null ? '${s.reps}' : '-',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      s.rir != null ? '${s.rir}' : '-',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RutinaCard extends StatelessWidget {
  final RutinaModel rutina;

  const _RutinaCard({required this.rutina});

  @override
  Widget build(BuildContext context) {
    final dias = rutina.ejercicios.map((e) => e.diaSemana).toSet().toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ExpansionTile(
            tilePadding: const EdgeInsets.all(16),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            title: Text(
              rutina.nombre,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Entrenador: ${rutina.entrenadorNombre}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  children: dias
                      .map(
                        (dia) => Chip(
                          label: Text(
                            dia,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: const Color(0xFF6C63FF),
                          padding: EdgeInsets.zero,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            children: rutina.ejercicios
                .map((e) => _EjercicioTile(ejercicio: e))
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EntrenamientoScreen(rutina: rutina),
                  ),
                ),
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                label: const Text(
                  'Iniciar entrenamiento',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EjercicioTile extends StatelessWidget {
  final EjercicioRutina ejercicio;

  const _EjercicioTile({required this.ejercicio});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.fitness_center, color: Color(0xFF6C63FF), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ejercicio.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ejercicio.musculoObjetivo ?? '',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${ejercicio.series} series x ${ejercicio.repeticiones}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(
                'Descanso: ${ejercicio.descanso}',
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
              Text(
                ejercicio.diaSemana,
                style: const TextStyle(color: Color(0xFF6C63FF), fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
