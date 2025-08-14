import 'dart:io';
import '../entities/disease_prediction.dart';

abstract class DiseaseDetectionInterface {
  Future<DiseasePrediction> predictDisease(File imageFile);
  Future<Map<String, dynamic>> getModelInfo();
  Future<List<String>> getAvailableClasses();
  Future<bool> checkApiHealth();
}