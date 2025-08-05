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

  void _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    await widget.controller.send(text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.controller.chat;

    return Scaffold(
      appBar: AppBar(title: const Text("Asistente agrícola")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (_, index) {
                final Message msg = messages[index];
                return Align(
                  alignment:
                  msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
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
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Escribe tu pregunta...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _handleSend,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
