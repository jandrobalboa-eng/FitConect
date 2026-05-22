import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../perfil/screens/perfil_screen.dart';
import '../rutinas/screens/rutinas_screen.dart';
import '../ejercicios/screens/ejercicios_screen.dart';
import '../metricas/screens/metricas_screen.dart';
import '../chat/screens/chat_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final VoidCallback onLogout;

  const HomeScreen({super.key, required this.onLogout});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const RutinasScreen(),
      const EjerciciosScreen(),
      const MetricasScreen(),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Rutinas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Ejercicios'),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Métricas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: 'FitBot'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
