import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/perfil_provider.dart';
import '../../auth/providers/auth_provider.dart';

class PerfilScreen extends ConsumerWidget {
  final VoidCallback onLogout;

  const PerfilScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfilAsync = ref.watch(perfilProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Mi perfil', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              onLogout();
            },
          ),
        ],
      ),
      body: perfilAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(e.toString(), style: const TextStyle(color: Colors.red)),
        ),
        data: (perfil) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: const Color(0xFF6C63FF),
                  child: Text(
                    perfil.nombre.isNotEmpty
                        ? perfil.nombre[0].toUpperCase()
                        : '?',
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _infoCard('Nombre', perfil.nombre),
              _infoCard('Email', perfil.email),
              _infoCard('Rol', perfil.rol),
              if (perfil.objetivo != null)
                _infoCard('Objetivo', perfil.objetivo!),
              if (perfil.altura != null)
                _infoCard('Altura', '${perfil.altura} m'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String label, String value) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF1E1E1E),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(color: Colors.white)),
      ],
    ),
  );
}
