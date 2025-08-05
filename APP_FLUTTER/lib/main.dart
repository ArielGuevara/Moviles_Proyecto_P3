import 'package:flutter/material.dart';
import 'package:pry_final/adapters/ui/chatbot_screen.dart';
import 'package:pry_final/application/chatbot_controller.dart';
import 'package:pry_final/core/domain/usecases/send_message_usecase.dart';
import 'package:pry_final/infrastructure/services/ollama_chat_service.dart';

void main() {
  final chatbot = OllamaChatService();
  final usecase = SendMessageUseCase(chatbot);
  final controller = ChatbotController(usecase);

  runApp(MyApp(controller: controller));
}

class MyApp extends StatelessWidget {
  final ChatbotController controller;

  const MyApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asistente Agrícola',
      home: ChatbotScreen(controller: controller),
      debugShowCheckedModeBanner: false,
    );
  }
}
