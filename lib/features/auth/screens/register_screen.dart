import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final VoidCallback onRegisterSuccess;
  final VoidCallback onGoToLogin;

  const RegisterScreen({
    super.key,
    required this.onRegisterSuccess,
    required this.onGoToLogin,
  });

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _nombreError;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validar() {
    setState(() {
      _nombreError = null;
      _emailError = null;
      _passwordError = null;
    });

    bool valido = true;

    if (_nombreController.text.trim().isEmpty) {
      setState(() => _nombreError = 'El nombre es obligatorio');
      valido = false;
    } else if (_nombreController.text.trim().length < 3) {
      setState(() => _nombreError = 'Mínimo 3 caracteres');
      valido = false;
    }

    if (_emailController.text.trim().isEmpty) {
      setState(() => _emailError = 'El email es obligatorio');
      valido = false;
    } else if (!_emailController.text.contains('@')) {
      setState(() => _emailError = 'Introduce un email válido');
      valido = false;
    }

    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = 'La contraseña es obligatoria');
      valido = false;
    } else if (_passwordController.text.length < 6) {
      setState(() => _passwordError = 'Mínimo 6 caracteres');
      valido = false;
    }

    return valido;
  }

  Future<void> _handleRegister() async {
    if (!_validar()) return;
    final success = await ref
        .read(authProvider.notifier)
        .register(
          _nombreController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );
    if (success) widget.onRegisterSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: widget.onGoToLogin,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Crear cuenta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Rellena los datos para registrarte',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _nombreController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  'Nombre completo',
                  Icons.person_outline,
                  errorText: _nombreError,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  'Email',
                  Icons.email_outlined,
                  errorText: _emailError,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration:
                    _inputDecoration(
                      'Contraseña',
                      Icons.lock_outlined,
                      errorText: _passwordError,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
              ),
              const SizedBox(height: 12),
              if (authState.error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.redAccent),
                  ),
                  child: Text(
                    authState.error!,
                    style: const TextStyle(color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: authState.isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: authState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Registrarse',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    String? errorText,
  }) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.grey),
    prefixIcon: Icon(icon, color: Colors.grey),
    errorText: errorText,
    errorStyle: const TextStyle(color: Colors.redAccent),
    filled: true,
    fillColor: const Color(0xFF1E1E1E),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
    ),
  );
}
