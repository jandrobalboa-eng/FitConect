import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/rutina_entrenador_model.dart';
import '../providers/rutinas_entrenador_provider.dart';

class DetalleRutinaEntrenadorScreen extends ConsumerStatefulWidget {
  final RutinaEntrenador rutina;

  const DetalleRutinaEntrenadorScreen({super.key, required this.rutina});

  @override
  ConsumerState<DetalleRutinaEntrenadorScreen> createState() =>
      _DetalleRutinaEntrenadorScreenState();
}

class _DetalleRutinaEntrenadorScreenState
    extends ConsumerState<DetalleRutinaEntrenadorScreen> {
  late RutinaEntrenador _rutina;
  int _semanaActual = 0;

  @override
  void initState() {
    super.initState();
    _rutina = widget.rutina;
  }

  Future<void> _guardar() async {
    await ref.read(rutinasEntrenadorProvider.notifier).actualizar(_rutina);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Rutina guardada'),
          backgroundColor: Color(0xFF6C63FF),
        ),
      );
    }
  }

  void _anadirSemana() {
    setState(() {
      final nuevaSemana = SemanaEntrenador(
        numero: _rutina.semanas.length + 1,
        dias: List.generate(
          _rutina.diasPorSemana,
          (i) => DiaEntrenador(nombre: _rutina.nombreDias[i]),
        ),
      );
      _rutina.semanas.add(nuevaSemana);
    });
  }

  void _anadirEjercicio(int diaIndex) {
    setState(() {
      _rutina.semanas[_semanaActual].dias[diaIndex].ejercicios.add(
        EjercicioEntrenador(),
      );
    });
  }

  void _borrarEjercicio(int diaIndex, int ejercicioIndex) {
    setState(() {
      _rutina.semanas[_semanaActual].dias[diaIndex].ejercicios.removeAt(
        ejercicioIndex,
      );
    });
  }

  void _anadirSerie(int diaIndex, int ejercicioIndex) {
    setState(() {
      _rutina
          .semanas[_semanaActual]
          .dias[diaIndex]
          .ejercicios[ejercicioIndex]
          .series
          .add(SerieEntrenador());
    });
  }

  void _borrarSerie(int diaIndex, int ejercicioIndex, int serieIndex) {
    setState(() {
      _rutina
          .semanas[_semanaActual]
          .dias[diaIndex]
          .ejercicios[ejercicioIndex]
          .series
          .removeAt(serieIndex);
    });
  }

  Future<void> _seleccionarFecha(int diaIndex) async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF6C63FF),
            surface: Color(0xFF1E1E1E),
          ),
        ),
        child: child!,
      ),
    );

    if (fecha != null) {
      setState(() {
        _rutina.semanas[_semanaActual].dias[diaIndex].fechaRealizacion =
            '${fecha.day}/${fecha.month}/${fecha.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final semana = _rutina.semanas[_semanaActual];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          _rutina.nombreCompleto,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Color(0xFF6C63FF)),
            onPressed: _guardar,
          ),
        ],
      ),
      body: Column(
        children: [
          // Selector de semanas
          Container(
            height: 50,
            color: const Color(0xFF1E1E1E),
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: _rutina.semanas.length,
                    itemBuilder: (context, i) {
                      final seleccionada = _semanaActual == i;
                      return GestureDetector(
                        onTap: () => setState(() => _semanaActual = i),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 8,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: seleccionada
                                ? const Color(0xFF6C63FF)
                                : const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'Semana ${i + 1}',
                              style: TextStyle(
                                color: seleccionada
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFF6C63FF)),
                  onPressed: _anadirSemana,
                  tooltip: 'Añadir semana',
                ),
              ],
            ),
          ),
          // Días
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: semana.dias.length,
              itemBuilder: (context, diaIndex) {
                final dia = semana.dias[diaIndex];
                return _DiaCard(
                  dia: dia,
                  diaIndex: diaIndex,
                  onSeleccionarFecha: () => _seleccionarFecha(diaIndex),
                  onAnadirEjercicio: () => _anadirEjercicio(diaIndex),
                  onBorrarEjercicio: (eIdx) => _borrarEjercicio(diaIndex, eIdx),
                  onAnadirSerie: (eIdx) => _anadirSerie(diaIndex, eIdx),
                  onBorrarSerie: (eIdx, sIdx) =>
                      _borrarSerie(diaIndex, eIdx, sIdx),
                  onChanged: () => setState(() {}),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DiaCard extends StatelessWidget {
  final DiaEntrenador dia;
  final int diaIndex;
  final VoidCallback onSeleccionarFecha;
  final VoidCallback onAnadirEjercicio;
  final Function(int) onBorrarEjercicio;
  final Function(int) onAnadirSerie;
  final Function(int, int) onBorrarSerie;
  final VoidCallback onChanged;

  const _DiaCard({
    required this.dia,
    required this.diaIndex,
    required this.onSeleccionarFecha,
    required this.onAnadirEjercicio,
    required this.onBorrarEjercicio,
    required this.onAnadirSerie,
    required this.onBorrarSerie,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera día
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF6C63FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dia.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                GestureDetector(
                  onTap: onSeleccionarFecha,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          dia.fechaRealizacion.isEmpty
                              ? 'Fecha'
                              : dia.fechaRealizacion,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Ejercicios
          ...dia.ejercicios.asMap().entries.map((entry) {
            final eIdx = entry.key;
            final ejercicio = entry.value;
            return _EjercicioCard(
              ejercicio: ejercicio,
              eIdx: eIdx,
              onBorrar: () => onBorrarEjercicio(eIdx),
              onAnadirSerie: () => onAnadirSerie(eIdx),
              onBorrarSerie: (sIdx) => onBorrarSerie(eIdx, sIdx),
              onChanged: onChanged,
            );
          }),
          // Botón añadir ejercicio
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextButton.icon(
              onPressed: onAnadirEjercicio,
              icon: const Icon(Icons.add, color: Color(0xFF6C63FF)),
              label: const Text(
                'Añadir ejercicio',
                style: TextStyle(color: Color(0xFF6C63FF)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EjercicioCard extends StatelessWidget {
  final EjercicioEntrenador ejercicio;
  final int eIdx;
  final VoidCallback onBorrar;
  final VoidCallback onAnadirSerie;
  final Function(int) onBorrarSerie;
  final VoidCallback onChanged;

  const _EjercicioCard({
    required this.ejercicio,
    required this.eIdx,
    required this.onBorrar,
    required this.onAnadirSerie,
    required this.onBorrarSerie,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: TextEditingController(text: ejercicio.nombre)
                    ..selection = TextSelection.collapsed(
                      offset: ejercicio.nombre.length,
                    ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: _deco('Nombre del ejercicio'),
                  onChanged: (v) {
                    ejercicio.nombre = v;
                    onChanged();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: TextEditingController(text: ejercicio.descanso)
                    ..selection = TextSelection.collapsed(
                      offset: ejercicio.descanso.length,
                    ),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: _deco('Desc.'),
                  onChanged: (v) {
                    ejercicio.descanso = v;
                    onChanged();
                  },
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                  size: 20,
                ),
                onPressed: onBorrar,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              SizedBox(width: 24),
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
              Expanded(
                child: Text(
                  'Notas',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF6C63FF), fontSize: 11),
                ),
              ),
              SizedBox(width: 32),
            ],
          ),
          const SizedBox(height: 4),
          ...ejercicio.series.asMap().entries.map((entry) {
            final sIdx = entry.key;
            final serie = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    child: Text(
                      '${sIdx + 1}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _miniInput(
                      serie.peso,
                      (v) => serie.peso = v,
                      onChanged,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: _miniInput(
                      serie.reps,
                      (v) => serie.reps = v,
                      onChanged,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: _miniInput(
                      serie.rir,
                      (v) => serie.rir = v,
                      onChanged,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: _miniInput(
                      serie.notas,
                      (v) => serie.notas = v,
                      onChanged,
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    child: ejercicio.series.length > 1
                        ? IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.redAccent,
                              size: 18,
                            ),
                            onPressed: () => onBorrarSerie(sIdx),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            );
          }),
          TextButton.icon(
            onPressed: onAnadirSerie,
            icon: const Icon(Icons.add, color: Color(0xFF6C63FF), size: 16),
            label: const Text(
              'Añadir serie',
              style: TextStyle(color: Color(0xFF6C63FF), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniInput(
    String valor,
    Function(String) onChange,
    VoidCallback onChanged,
  ) => TextField(
    controller: TextEditingController(text: valor)
      ..selection = TextSelection.collapsed(offset: valor.length),
    textAlign: TextAlign.center,
    style: const TextStyle(color: Colors.white, fontSize: 12),
    decoration: InputDecoration(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
    ),
    onChanged: (v) {
      onChange(v);
      onChanged();
    },
  );

  InputDecoration _deco(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
    filled: true,
    fillColor: const Color(0xFF1E1E1E),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  );
}
