import 'package:flutter/material.dart';
import '../../application/chatbot_controller.dart';
import '../../core/domain/entities/message.dart';

class ChatbotScreen extends StatefulWidget {
  final ChatbotController controller;

  const ChatbotScreen({super.key, required this.controller});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _controller = TextEditingController();
  bool isLoading = false;

  void _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    _controller.clear();
    await widget.controller.send(text);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _clearChat() async {
    await widget.controller.storage.save([]); // Borra en SharedPreferences
    setState(() {
      widget.controller.chat.clear(); // Borra en memoria
    });
  }

  void _navigateToVision() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlaceholderScreen(title: "Visión por Computadora")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.controller.chat;

    return Scaffold(
      appBar: AppBar(title: const Text("Asistente agrícola 🤖🌱")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.ac_unit_rounded, size: 50, color: Colors.white),
                  Text("Menu de Navegación", style: TextStyle(fontSize: 22, color: Colors.white),),
                  Text("Universidad de las Fuerzas Armadas ESPE", style: TextStyle(fontSize: 10, color: Colors.white70),),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text("Chatbot"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Visión por Computadora"),
              onTap: () {
                Navigator.pop(context);
                _navigateToVision();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (_, index) {
                final Message msg = messages[index];
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isUser ? Colors.green[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg.text),
                  ),
                );
              },
            ),
          ),
          if (isLoading)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(width: 12),
                  Text("Generando respuesta..."),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.settings),
                  onSelected: (value) {
                    if (value == 'clear') _clearChat();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'clear',
                      child: Text('Borrar chat'),
                    ),
                  ],
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Escribe tu pregunta...",
                      border: OutlineInputBorder(),
                    ),
                    enabled: !isLoading,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: isLoading ? null : _handleSend,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Pantalla de ejemplo para navegación
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("Aquí irá la funcionalidad de $title")),
    );
  }
}