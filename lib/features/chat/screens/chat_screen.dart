import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class Mensaje {
  final String texto;
  final bool esUsuario;

  Mensaje({required this.texto, required this.esUsuario});
}

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<Mensaje> _mensajes = [];
  bool _cargando = false;

  final _dio = Dio();
  static const _apiKey = 'GROQ_API_KEY';
  static const _systemPrompt = '''
Eres FitBot, un asistente de fitness personal integrado en FitConnect.
Ayudas a los usuarios con:
- Consejos sobre ejercicios y técnica
- Explicaciones sobre rutinas de entrenamiento
- Información sobre nutrición y recuperación
- Motivación y seguimiento de objetivos
- Interpretación de métricas corporales (peso, cintura, cadera)
- Qué significa el RIR (Reps In Reserve) y cómo usarlo

Responde siempre en español, de forma clara, motivadora y profesional.
Sé conciso pero completo. Usa emojis ocasionalmente para hacer la conversación más amena.
''';

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty || _cargando) return;

    setState(() {
      _mensajes.add(Mensaje(texto: texto, esUsuario: true));
      _cargando = true;
    });
    _controller.clear();
    _scrollAbajo();

    try {
      final historial = _mensajes
          .sublist(0, _mensajes.length - 1)
          .map(
            (m) => {
              'role': m.esUsuario ? 'user' : 'assistant',
              'content': m.texto,
            },
          )
          .toList();

      historial.add({'role': 'user', 'content': texto});

      final response = await _dio.post(
        'https://api.groq.com/openai/v1/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: jsonEncode({
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {'role': 'system', 'content': _systemPrompt},
            ...historial,
          ],
          'max_tokens': 1024,
        }),
      );

      final respuesta =
          response.data['choices'][0]['message']['content'] as String;

      setState(() {
        _mensajes.add(Mensaje(texto: respuesta, esUsuario: false));
        _cargando = false;
      });
      _scrollAbajo();
    } catch (e) {
      setState(() {
        _mensajes.add(
          Mensaje(
            texto: 'Error al conectar con FitBot. Inténtalo de nuevo.',
            esUsuario: false,
          ),
        );
        _cargando = false;
      });
    }
  }

  void _scrollAbajo() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFF6C63FF),
              radius: 16,
              child: Icon(Icons.smart_toy, color: Colors.white, size: 18),
            ),
            SizedBox(width: 8),
            Text('FitBot', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _mensajes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF6C63FF,
                            ).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.smart_toy,
                            size: 40,
                            color: Color(0xFF6C63FF),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '¡Hola! Soy FitBot 💪',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Pregúntame sobre ejercicios,\nnutrición o tu progreso',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        _sugerencia('¿Qué es el RIR?'),
                        _sugerencia('¿Cómo mejorar mi sentadilla?'),
                        _sugerencia('¿Cuánto descanso necesito?'),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _mensajes.length,
                    itemBuilder: (context, index) {
                      final msg = _mensajes[index];
                      return _BurbujaMensaje(mensaje: msg);
                    },
                  ),
          ),
          if (_cargando)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF6C63FF),
                    radius: 14,
                    child: Icon(Icons.smart_toy, color: Colors.white, size: 14),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'FitBot está escribiendo...',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E1E1E),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    onSubmitted: (_) => _enviar(),
                    decoration: InputDecoration(
                      hintText: 'Escribe tu pregunta...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _enviar,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6C63FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sugerencia(String texto) => GestureDetector(
    onTap: () {
      _controller.text = texto;
      _enviar();
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6C63FF)),
      ),
      child: Text(texto, style: const TextStyle(color: Color(0xFF6C63FF))),
    ),
  );
}

class _BurbujaMensaje extends StatelessWidget {
  final Mensaje mensaje;

  const _BurbujaMensaje({required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mensaje.esUsuario
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: mensaje.esUsuario
              ? const Color(0xFF6C63FF)
              : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(mensaje.esUsuario ? 16 : 4),
            bottomRight: Radius.circular(mensaje.esUsuario ? 4 : 16),
          ),
        ),
        child: Text(
          mensaje.texto,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
