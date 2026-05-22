import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/metricas_provider.dart';
import '../models/metrica_model.dart';
import '../../../shared/widgets/error_widget.dart';

class MetricasScreen extends ConsumerStatefulWidget {
  const MetricasScreen({super.key});

  @override
  ConsumerState<MetricasScreen> createState() => _MetricasScreenState();
}

class _MetricasScreenState extends ConsumerState<MetricasScreen> {
  final _pesoController = TextEditingController();
  final _cinturaController = TextEditingController();
  final _caderaController = TextEditingController();
  final _notasController = TextEditingController();

  @override
  void dispose() {
    _pesoController.dispose();
    _cinturaController.dispose();
    _caderaController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (_pesoController.text.isEmpty &&
        _cinturaController.text.isEmpty &&
        _caderaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Introduce al menos un valor'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final fecha = DateTime.now().toIso8601String().split('T')[0];
    final success = await ref
        .read(metricasNotifierProvider.notifier)
        .registrarMetrica(
          fecha: fecha,
          peso: double.tryParse(_pesoController.text),
          medidaCintura: double.tryParse(_cinturaController.text),
          medidaCadera: double.tryParse(_caderaController.text),
          notas: _notasController.text.isEmpty ? null : _notasController.text,
        );
    if (success) {
      _pesoController.clear();
      _cinturaController.clear();
      _caderaController.clear();
      _notasController.clear();
      ref.invalidate(metricasProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Métrica registrada correctamente'),
            backgroundColor: Color(0xFF6C63FF),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final metricasAsync = ref.watch(metricasProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Métricas', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref.invalidate(metricasProvider),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Formulario registro
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.add_circle, color: Color(0xFF6C63FF)),
                      SizedBox(width: 8),
                      Text(
                        'Registrar hoy',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _inputField(
                    _pesoController,
                    'Peso (kg)',
                    Icons.monitor_weight_outlined,
                  ),
                  const SizedBox(height: 12),
                  _inputField(
                    _cinturaController,
                    'Cintura (cm)',
                    Icons.straighten,
                  ),
                  const SizedBox(height: 12),
                  _inputField(
                    _caderaController,
                    'Cadera (cm)',
                    Icons.straighten,
                  ),
                  const SizedBox(height: 12),
                  _inputField(
                    _notasController,
                    'Notas',
                    Icons.note_outlined,
                    isNumber: false,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _registrar,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Guardar',
                        style: TextStyle(color: Colors.white, fontSize: 16),
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
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Gráfica
            const Row(
              children: [
                Icon(Icons.show_chart, color: Color(0xFF6C63FF)),
                SizedBox(width: 8),
                Text(
                  'Progreso de peso',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            metricasAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => AppErrorWidget(
                mensaje: e.toString(),
                onRetry: () => ref.invalidate(metricasProvider),
              ),
              data: (metricas) {
                final conPeso = metricas.where((m) => m.peso != null).toList();
                if (conPeso.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Column(
                        children: [
                          Icon(Icons.show_chart, size: 48, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            'Sin datos de peso aún',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return _GraficaPeso(metricas: conPeso);
              },
            ),
            const SizedBox(height: 24),

            // Historial tabla
            const Row(
              children: [
                Icon(Icons.table_rows, color: Color(0xFF6C63FF)),
                SizedBox(width: 8),
                Text(
                  'Historial',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            metricasAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const SizedBox(),
              data: (metricas) {
                if (metricas.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'Sin registros aún',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
                return _TablaHistorial(metricas: metricas);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumber = true,
  }) => TextField(
    controller: controller,
    keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
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

class _TablaHistorial extends StatelessWidget {
  final List<MetricaModel> metricas;

  const _TablaHistorial({required this.metricas});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFF2A2A2A)),
          dataRowColor: WidgetStateProperty.resolveWith((states) {
            return const Color(0xFF1E1E1E);
          }),
          columns: const [
            DataColumn(
              label: Text(
                'Fecha',
                style: TextStyle(
                  color: Color(0xFF6C63FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Peso',
                style: TextStyle(
                  color: Color(0xFF6C63FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Cintura',
                style: TextStyle(
                  color: Color(0xFF6C63FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Cadera',
                style: TextStyle(
                  color: Color(0xFF6C63FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Notas',
                style: TextStyle(
                  color: Color(0xFF6C63FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          rows: metricas.map((m) {
            return DataRow(
              cells: [
                DataCell(
                  Text(m.fecha, style: const TextStyle(color: Colors.white)),
                ),
                DataCell(
                  Text(
                    m.peso != null ? '${m.peso} kg' : '-',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                DataCell(
                  Text(
                    m.medidaCintura != null ? '${m.medidaCintura} cm' : '-',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                DataCell(
                  Text(
                    m.medidaCadera != null ? '${m.medidaCadera} cm' : '-',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 120,
                    child: Text(
                      m.notas ?? '-',
                      style: const TextStyle(color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _GraficaPeso extends StatelessWidget {
  final List<MetricaModel> metricas;

  const _GraficaPeso({required this.metricas});

  @override
  Widget build(BuildContext context) {
    final spots = metricas.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.peso!);
    }).toList();

    final minY =
        metricas.map((m) => m.peso!).reduce((a, b) => a < b ? a : b) - 2;
    final maxY =
        metricas.map((m) => m.peso!).reduce((a, b) => a > b ? a : b) + 2;

    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (value, _) => Text(
                  '${value.toInt()}kg',
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final index = value.toInt();
                  if (index < 0 || index >= metricas.length) {
                    return const SizedBox();
                  }
                  final fecha = metricas[index].fecha;
                  final partes = fecha.split('-');
                  return Text(
                    '${partes[2]}/${partes[1]}',
                    style: const TextStyle(color: Colors.grey, fontSize: 9),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: const Color(0xFF6C63FF),
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
