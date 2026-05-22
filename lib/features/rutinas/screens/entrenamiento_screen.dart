import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/rutina_model.dart';
import '../models/entrenamiento_model.dart';
import '../providers/entrenamiento_provider.dart';

class EntrenamientoScreen extends ConsumerStatefulWidget {
  final RutinaModel rutina;
  final EntrenamientoRealizado? entrenamientoExistente;
  final int? entrenamientoIndex;

  const EntrenamientoScreen({
    super.key,
    required this.rutina,
    this.entrenamientoExistente,
    this.entrenamientoIndex,
  });

  @override
  ConsumerState<EntrenamientoScreen> createState() =>
      _EntrenamientoScreenState();
}

class _EntrenamientoScreenState extends ConsumerState<EntrenamientoScreen> {
  final Map<int, List<Map<String, TextEditingController>>> _controllers = {};
  int? _timerSegundos;
  bool _timerActivo = false;
  int _timerVersion = 0;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.rutina.ejercicios.length; i++) {
      final ejercicio = widget.rutina.ejercicios[i];
      _controllers[i] = List.generate(ejercicio.series, (s) {
        String peso = '';
        String reps = '';
        String rir = '';

        if (widget.entrenamientoExistente != null) {
          final ejercExistente = widget.entrenamientoExistente!.ejercicios
              .where((e) => e.ejercicioId == ejercicio.id)
              .firstOrNull;
          if (ejercExistente != null && s < ejercExistente.series.length) {
            final serie = ejercExistente.series[s];
            peso = serie.peso?.toString() ?? '';
            reps = serie.reps?.toString() ?? '';
            rir = serie.rir?.toString() ?? '';
          }
        }

        return {
          'peso': TextEditingController(text: peso),
          'reps': TextEditingController(text: reps),
          'rir': TextEditingController(text: rir),
        };
      });
    }
  }

  @override
  void dispose() {
    _timerActivo = false;
    for (final ejercicio in _controllers.values) {
      for (final serie in ejercicio) {
        serie['peso']!.dispose();
        serie['reps']!.dispose();
        serie['rir']!.dispose();
      }
    }
    super.dispose();
  }

  void _iniciarTimer(int segundos) {
    _timerVersion++;
    final miVersion = _timerVersion;
    setState(() {
      _timerSegundos = segundos;
      _timerActivo = true;
    });
    _tickTimer(miVersion, segundos);
  }

  void _tickTimer(int version, int segundosInicial) async {
    var segundos = segundosInicial;
    while (segundos > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || _timerVersion != version) return;
      segundos--;
      setState(() => _timerSegundos = segundos);
    }
    if (!mounted || _timerVersion != version) return;
    setState(() => _timerActivo = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('⏱️ ¡Descanso terminado!'),
        backgroundColor: Color(0xFF6C63FF),
      ),
    );
  }

  Future<void> _guardarEntrenamiento() async {
    final ejerciciosRealizados = <EjercicioRealizado>[];

    for (var i = 0; i < widget.rutina.ejercicios.length; i++) {
      final ejercicio = widget.rutina.ejercicios[i];
      final series = <SerieRealizada>[];

      for (var s = 0; s < ejercicio.series; s++) {
        final ctrl = _controllers[i]![s];
        series.add(
          SerieRealizada(
            numSerie: s + 1,
            peso: double.tryParse(ctrl['peso']!.text),
            reps: int.tryParse(ctrl['reps']!.text),
            rir: int.tryParse(ctrl['rir']!.text),
          ),
        );
      }

      ejerciciosRealizados.add(
        EjercicioRealizado(
          ejercicioId: ejercicio.id,
          nombre: ejercicio.nombre,
          series: series,
        ),
      );
    }

    final entrenamiento = EntrenamientoRealizado(
      rutinaId: widget.rutina.id,
      fecha:
          widget.entrenamientoExistente?.fecha ??
          DateTime.now().toIso8601String().split('T')[0],
      ejercicios: ejerciciosRealizados,
    );

    if (widget.entrenamientoIndex != null) {
      await ref
          .read(entrenamientoProvider.notifier)
          .editar(widget.entrenamientoIndex!, entrenamiento);
    } else {
      await ref.read(entrenamientoProvider.notifier).guardar(entrenamiento);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.entrenamientoIndex != null
                ? '✅ Entrenamiento actualizado'
                : '✅ Entrenamiento guardado',
          ),
          backgroundColor: const Color(0xFF6C63FF),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          widget.entrenamientoIndex != null
              ? 'Editar entrenamiento'
              : widget.rutina.nombre,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          if (_timerActivo || _timerSegundos != null)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _timerSegundos == 0
                    ? Colors.green.withValues(alpha: 0.2)
                    : const Color(0xFF6C63FF).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _timerSegundos == 0
                      ? Colors.green
                      : const Color(0xFF6C63FF),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.timer, color: Colors.white),
                  Text(
                    _timerSegundos == 0
                        ? '¡Listo!'
                        : '${_timerSegundos}s restantes',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => setState(() {
                      _timerVersion++;
                      _timerActivo = false;
                      _timerSegundos = null;
                    }),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.rutina.ejercicios.length,
              itemBuilder: (context, i) {
                final ejercicio = widget.rutina.ejercicios[i];
                return _EjercicioCard(
                  ejercicio: ejercicio,
                  controllers: _controllers[i]!,
                  onDescanso: () {
                    final segundos =
                        int.tryParse(ejercicio.descanso.replaceAll('s', '')) ??
                        60;
                    _iniciarTimer(segundos);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _guardarEntrenamiento,
                icon: const Icon(Icons.save, color: Colors.white),
                label: Text(
                  widget.entrenamientoIndex != null
                      ? 'Actualizar entrenamiento'
                      : 'Guardar entrenamiento',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
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

class _EjercicioCard extends StatelessWidget {
  final EjercicioRutina ejercicio;
  final List<Map<String, TextEditingController>> controllers;
  final VoidCallback onDescanso;

  const _EjercicioCard({
    required this.ejercicio,
    required this.controllers,
    required this.onDescanso,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  ejercicio.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: onDescanso,
                icon: const Icon(Icons.timer, color: Color(0xFF6C63FF)),
                label: Text(
                  ejercicio.descanso,
                  style: const TextStyle(color: Color(0xFF6C63FF)),
                ),
              ),
            ],
          ),
          Text(
            '${ejercicio.series} series × ${ejercicio.repeticiones} reps — ${ejercicio.diaSemana}',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              SizedBox(width: 40),
              Expanded(
                child: Text(
                  'Peso (kg)',
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
          const SizedBox(height: 8),
          ...List.generate(ejercicio.series, (s) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Text(
                      'S${s + 1}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(child: _miniInput(controllers[s]['peso']!)),
                  const SizedBox(width: 8),
                  Expanded(child: _miniInput(controllers[s]['reps']!)),
                  const SizedBox(width: 8),
                  Expanded(child: _miniInput(controllers[s]['rir']!)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _miniInput(TextEditingController controller) => TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    textAlign: TextAlign.center,
    style: const TextStyle(color: Colors.white, fontSize: 14),
    decoration: InputDecoration(
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    ),
  );
}
