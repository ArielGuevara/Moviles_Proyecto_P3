import 'dart:io';
import '../interfaces/disease_detection_interface.dart';
import '../entities/disease_prediction.dart';

class DetectDiseaseUseCase {
  final DiseaseDetectionInterface diseaseDetection;

  DetectDiseaseUseCase(this.diseaseDetection);

  Future<DiseasePrediction> execute(File imageFile) async {
    return await diseaseDetection.predictDisease(imageFile);
  }
}