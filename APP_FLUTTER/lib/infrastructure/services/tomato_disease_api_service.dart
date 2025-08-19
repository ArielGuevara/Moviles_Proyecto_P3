import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/domain/interfaces/disease_detection_interface.dart';
import '../../core/domain/entities/disease_prediction.dart';

class TomatoDiseaseApiService implements DiseaseDetectionInterface {
  final String baseUrl;

  TomatoDiseaseApiService({
    this.baseUrl = "http://192.168.100.68:8001", // Cambia por tu API URL
  });

  @override
  Future<DiseasePrediction> predictDisease(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/predict'),
      );

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          return DiseasePrediction.fromJson(jsonData);
        } else {
          throw Exception('Error en la predicción: ${jsonData['message']}');
        }
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al comunicarse con la API: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getModelInfo() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/model/info'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener información del modelo: $e');
    }
  }

  @override
  Future<List<String>> getAvailableClasses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/classes'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<String>.from(data['classes']);
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener clases disponibles: $e');
    }
  }

  @override
  Future<bool> checkApiHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['status'] == 'healthy';
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}