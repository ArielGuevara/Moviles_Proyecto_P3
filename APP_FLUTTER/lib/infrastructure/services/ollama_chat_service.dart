import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/domain/interfaces/chatbot_interface.dart';

class OllamaChatService implements ChatbotInterface {
  final String baseUrl;
  final String modelName;

  OllamaChatService({
    this.baseUrl = "http://192.168.100.68:8001",
    this.modelName = "llama3",
  });

  @override
  Future<String> sendMessage(String prompt) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/generate_stream'),
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'FlutterApp/1.0'
      },
      body: jsonEncode({
        "model": modelName,
        "prompt": prompt,
        "stream": true
      }),
    );

    if (response.statusCode == 200) {
      // Procesa cada línea como JSON y extrae el campo 'response'
      final lines = response.body.split('\n');
      final buffer = StringBuffer();
      for (final line in lines) {
        if (line.trim().isEmpty) continue;
        try {
          final jsonLine = json.decode(line);
          if (jsonLine['response'] != null) {
            buffer.write(jsonLine['response']);
          }
        } catch (_) {
          // Ignora líneas que no sean JSON válidos
        }
      }
      return buffer.toString().trim();
    } else {
      throw Exception('Error al comunicarse con el backend');
    }
  }
}