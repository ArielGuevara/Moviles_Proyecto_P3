import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/domain/interfaces/chatbot_interface.dart';

class OllamaChatService implements ChatbotInterface {
  final String baseUrl;
  final String modelName;

  OllamaChatService({
    this.baseUrl = "http://192.168.100.68:8000", // o la IP local
    this.modelName = "llama3",
  });

  @override
  Future<String> sendMessage(String prompt) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/generate'),
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'FlutterApp/1.0'
      },
      body: jsonEncode({
        "model": modelName,
        "prompt": prompt,
        "stream": false
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response'] ?? "No response";
    } else {
      throw Exception('Error al comunicarse con Ollama');
    }
  }
}
