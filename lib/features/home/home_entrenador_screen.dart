import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entrenador/screens/clientes_screen.dart';
import '../entrenador/screens/rutinas_entrenador_screen.dart';
import '../chat/screens/chat_screen.dart';
import '../perfil/screens/perfil_screen.dart';

class HomeEntrenadorScreen extends ConsumerStatefulWidget {
  final VoidCallback onLogout;

  const HomeEntrenadorScreen({super.key, required this.onLogout});

  @override
  ConsumerState<HomeEntrenadorScreen> createState() =>
      _HomeEntrenadorScreenState();
}

class _HomeEntrenadorScreenState extends ConsumerState<HomeEntrenadorScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const ClientesScreen(),
      const RutinasEntrenadorScreen(),
      const ChatScreen(),
      PerfilScreen(onLogout: widget.onLogout),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: const Color(0xFF6C63FF),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clientes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Rutinas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: 'FitBot'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
