import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/storage/secure_storage.dart';
import 'features/splash/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/home/home_screen.dart';
import 'features/home/home_entrenador_screen.dart';

void main() {
  runApp(const ProviderScope(child: FitConnectApp()));
}

class FitConnectApp extends StatelessWidget {
  const FitConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(primary: Color(0xFF6C63FF)),
      ),
      home: const AppEntry(),
    );
  }
}

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool _showRegister = false;
  bool _isLoggedIn = false;
  bool _showSplash = true;
  String? _rol;

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashScreen(
        onAuthenticated: () async {
          final rol = await SecureStorage.getRol();
          setState(() {
            _showSplash = false;
            _isLoggedIn = true;
            _rol = rol;
          });
        },
        onUnauthenticated: () => setState(() {
          _showSplash = false;
          _isLoggedIn = false;
        }),
      );
    }

    if (_isLoggedIn) {
      if (_rol == 'entrenador') {
        return HomeEntrenadorScreen(
          onLogout: () => setState(() {
            _isLoggedIn = false;
            _rol = null;
          }),
        );
      }
      return HomeScreen(
        onLogout: () => setState(() {
          _isLoggedIn = false;
          _rol = null;
        }),
      );
    }

    if (_showRegister) {
      return RegisterScreen(
        onRegisterSuccess: () async {
          final rol = await SecureStorage.getRol();
          setState(() {
            _isLoggedIn = true;
            _rol = rol;
          });
        },
        onGoToLogin: () => setState(() => _showRegister = false),
      );
    }

    return LoginScreen(
      onLoginSuccess: () async {
        final rol = await SecureStorage.getRol();
        setState(() {
          _isLoggedIn = true;
          _rol = rol;
        });
      },
      onGoToRegister: () => setState(() => _showRegister = true),
    );
  }
}
