import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/rutina_entrenador_model.dart';
import '../providers/rutinas_entrenador_provider.dart';

class CrearRutinaScreen extends ConsumerStatefulWidget {
  const CrearRutinaScreen({super.key});

  @override
  ConsumerState<CrearRutinaScreen> createState() => _CrearRutinaScreenState();
}

class _CrearRutinaScreenState extends ConsumerState<CrearRutinaScreen> {
  final _tipoController = TextEditingController();
  int _diasPorSemana = 4;
  int _diaSeleccionado = 1;
  String _mesSeleccionado = 'Enero';
  String _anioSeleccionado = '2026';
  final List<TextEditingController> _nombreDiasControllers = [];

  String _clienteSeleccionado = 'María López';
  String _clienteEmailSeleccionado = 'cliente1@fitconnect.com';

  final List<Map<String, String>> _clientes = [
    {'nombre': 'María López', 'email': 'cliente1@fitconnect.com'},
    {'nombre': 'Carlos García', 'email': 'cliente2@fitconnect.com'},
  ];

  final List<String> _meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  final List<String> _anios = ['2025', '2026', '2027'];

  @override
  void initState() {
    super.initState();
    _actualizarDias();
  }

  void _actualizarDias() {
    _nombreDiasControllers.clear();
    for (var i = 0; i < _diasPorSemana; i++) {
      _nombreDiasControllers.add(TextEditingController(text: 'Día ${i + 1}'));
    }
  }

  @override
  void dispose() {
    _tipoController.dispose();
    for (final c in _nombreDiasControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _crear() async {
    if (_tipoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Introduce el tipo de rutina'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final nombreDias = _nombreDiasControllers
        .map((c) => c.text.trim())
        .toList();

    final fechaInicio =
        '$_diaSeleccionado/$_mesSeleccionado/$_anioSeleccionado';

    final rutina = RutinaEntrenador.crear(
      clienteNombre: _clienteSeleccionado,
      clienteEmail: _clienteEmailSeleccionado,
      tipo: _tipoController.text.trim(),
      mes: _mesSeleccionado,
      anio: _anioSeleccionado,
      dia: _diaSeleccionado.toString(),
      fechaInicio: fechaInicio,
      diasPorSemana: _diasPorSemana,
      nombreDias: nombreDias,
    );

    await ref.read(rutinasEntrenadorProvider.notifier).agregar(rutina);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Rutina creada correctamente'),
          backgroundColor: Color(0xFF6C63FF),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Crear rutina',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cliente
            _seccion('Cliente'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: _clienteSeleccionado,
                isExpanded: true,
                dropdownColor: const Color(0xFF1E1E1E),
                underline: const SizedBox(),
                style: const TextStyle(color: Colors.white),
                items: _clientes
                    .map(
                      (c) => DropdownMenuItem(
                        value: c['nombre'],
                        child: Text(c['nombre']!),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _clienteSeleccionado = val;
                      _clienteEmailSeleccionado = _clientes.firstWhere(
                        (c) => c['nombre'] == val,
                      )['email']!;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 16),

            // Tipo
            _seccion('Tipo de rutina'),
            _inputField(_tipoController, 'Ej: Torso/Pierna, Full Body...'),
            const SizedBox(height: 16),

            // Fecha inicio
            _seccion('Fecha de inicio'),
            Row(
              children: [
                // Día
                Container(
                  width: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<int>(
                    value: _diaSeleccionado,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1E1E1E),
                    underline: const SizedBox(),
                    style: const TextStyle(color: Colors.white),
                    items: List.generate(31, (i) => i + 1)
                        .map(
                          (d) => DropdownMenuItem(value: d, child: Text('$d')),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _diaSeleccionado = val!),
                  ),
                ),
                const SizedBox(width: 8),
                // Mes
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      value: _mesSeleccionado,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF1E1E1E),
                      underline: const SizedBox(),
                      style: const TextStyle(color: Colors.white),
                      items: _meses
                          .map(
                            (m) => DropdownMenuItem(value: m, child: Text(m)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _mesSeleccionado = val!),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Año
                Container(
                  width: 90,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: _anioSeleccionado,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1E1E1E),
                    underline: const SizedBox(),
                    style: const TextStyle(color: Colors.white),
                    items: _anios
                        .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _anioSeleccionado = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Días por semana
            _seccion('Días por semana'),
            Wrap(
              spacing: 8,
              children: [2, 3, 4, 5, 6].map((d) {
                final seleccionado = _diasPorSemana == d;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _diasPorSemana = d;
                      _actualizarDias();
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: seleccionado
                          ? const Color(0xFF6C63FF)
                          : const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: seleccionado
                            ? const Color(0xFF6C63FF)
                            : Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$d',
                        style: TextStyle(
                          color: seleccionado ? Colors.white : Colors.grey,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Nombre de los días
            _seccion('Nombre de los días'),
            ...List.generate(_diasPorSemana, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _inputField(
                        _nombreDiasControllers[i],
                        'Nombre del día',
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _crear,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Crear rutina',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _seccion(String titulo) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      titulo,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _inputField(TextEditingController controller, String hint) =>
      TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
          ),
        ),
      );
}
