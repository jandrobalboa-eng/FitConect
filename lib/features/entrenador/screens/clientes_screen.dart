import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cliente_model.dart';
import '../providers/clientes_entrenador_provider.dart';

class ClientesScreen extends ConsumerWidget {
  const ClientesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientes = ref.watch(clientesEntrenadorProvider);
    final proximosAVencer = clientes.where((c) => c.proximoAVencer).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Mis clientes',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarFormularioCliente(context, ref, null),
        backgroundColor: const Color(0xFF6C63FF),
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text(
          'Añadir cliente',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: clientes.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No tienes clientes aún',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Avisos de clientes próximos a vencer
                if (proximosAVencer.isNotEmpty) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.warning, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              '⚠️ Contratos próximos a vencer',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...proximosAVencer.map(
                          (c) => Text(
                            '${c.nombre} — ${c.diasRestantes} días restantes',
                            style: const TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                // Lista clientes
                ...clientes.map(
                  (cliente) => _ClienteCard(
                    cliente: cliente,
                    onEditar: () =>
                        _mostrarFormularioCliente(context, ref, cliente),
                    onEliminar: () async {
                      final confirmar = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: const Color(0xFF1E1E1E),
                          title: const Text(
                            'Eliminar cliente',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: const Text(
                            '¿Seguro que quieres eliminar este cliente?',
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
                                'Eliminar',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (confirmar == true) {
                        await ref
                            .read(clientesEntrenadorProvider.notifier)
                            .eliminar(cliente.id);
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _mostrarFormularioCliente(
    BuildContext context,
    WidgetRef ref,
    ClienteEntrenador? cliente,
  ) {
    final nombreCtrl = TextEditingController(text: cliente?.nombre ?? '');
    final emailCtrl = TextEditingController(text: cliente?.email ?? '');
    final objetivoCtrl = TextEditingController(text: cliente?.objetivo ?? '');
    int meses = cliente?.mesesContratados ?? 1;
    String fechaInicio = cliente?.fechaInicio ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cliente == null ? 'Añadir cliente' : 'Editar cliente',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _input(nombreCtrl, 'Nombre completo'),
                const SizedBox(height: 12),
                _input(emailCtrl, 'Email'),
                const SizedBox(height: 12),
                _input(objetivoCtrl, 'Objetivo'),
                const SizedBox(height: 16),
                const Text(
                  'Fecha de inicio',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
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
                      setModalState(() {
                        fechaInicio =
                            '${fecha.day}/${fecha.month}/${fecha.year}';
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          fechaInicio.isEmpty
                              ? 'Seleccionar fecha'
                              : fechaInicio,
                          style: TextStyle(
                            color: fechaInicio.isEmpty
                                ? Colors.grey
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Meses contratados',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Color(0xFF6C63FF),
                      ),
                      onPressed: () {
                        if (meses > 1) {
                          setModalState(() => meses--);
                        }
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$meses ${meses == 1 ? 'mes' : 'meses'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        color: Color(0xFF6C63FF),
                      ),
                      onPressed: () => setModalState(() => meses++),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (nombreCtrl.text.trim().isEmpty ||
                          fechaInicio.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Rellena el nombre y la fecha de inicio',
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }

                      final nuevoCliente = ClienteEntrenador(
                        id:
                            cliente?.id ??
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        nombre: nombreCtrl.text.trim(),
                        email: emailCtrl.text.trim(),
                        objetivo: objetivoCtrl.text.trim(),
                        fechaInicio: fechaInicio,
                        mesesContratados: meses,
                      );

                      if (cliente == null) {
                        await ref
                            .read(clientesEntrenadorProvider.notifier)
                            .agregar(nuevoCliente);
                      } else {
                        await ref
                            .read(clientesEntrenadorProvider.notifier)
                            .actualizar(nuevoCliente);
                      }

                      if (context.mounted) Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      cliente == null ? 'Añadir cliente' : 'Guardar cambios',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _input(TextEditingController ctrl, String hint) => TextField(
    controller: ctrl,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
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

class _ClienteCard extends StatelessWidget {
  final ClienteEntrenador cliente;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const _ClienteCard({
    required this.cliente,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final activo = cliente.estaActivo;
    final proximoAVencer = cliente.proximoAVencer;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: proximoAVencer
            ? Border.all(color: Colors.orange, width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: activo ? const Color(0xFF6C63FF) : Colors.grey,
            radius: 28,
            child: Text(
              cliente.nombre[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cliente.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (cliente.email.isNotEmpty)
                  Text(
                    cliente.email,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                const SizedBox(height: 4),
                if (cliente.objetivo.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      cliente.objetivo,
                      style: const TextStyle(
                        color: Color(0xFF6C63FF),
                        fontSize: 11,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: activo ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      activo
                          ? proximoAVencer
                                ? '⚠️ Vence en ${cliente.diasRestantes} días'
                                : 'Activo — ${cliente.mesesContratados} meses'
                          : 'Contrato vencido',
                      style: TextStyle(
                        color: proximoAVencer
                            ? Colors.orange
                            : activo
                            ? Colors.green
                            : Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF6C63FF)),
                onPressed: onEditar,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: onEliminar,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
