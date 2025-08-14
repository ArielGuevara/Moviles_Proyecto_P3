import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/domain/usecases/detect_disease_usecase.dart';
import '../core/domain/entities/disease_prediction.dart';

class DiseaseDetectionController extends ChangeNotifier {
  final DetectDiseaseUseCase detectDiseaseUseCase;
  final ImagePicker _picker = ImagePicker();

  DiseasePrediction? _lastPrediction;
  File? _selectedImage;
  bool _isLoading = false;
  String? _error;

  DiseaseDetectionController(this.detectDiseaseUseCase);

  DiseasePrediction? get lastPrediction => _lastPrediction;
  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (image != null) {
        _selectedImage = File(image.path);
        _error = null;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error al tomar foto: $e';
      notifyListeners();
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        _selectedImage = File(image.path);
        _error = null;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error al seleccionar imagen: $e';
      notifyListeners();
    }
  }

  Future<void> detectDisease() async {
    if (_selectedImage == null) {
      _error = 'Por favor selecciona una imagen';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _lastPrediction = await detectDiseaseUseCase.execute(_selectedImage!);
      _error = null;
    } catch (e) {
      _error = 'Error en la detección: $e';
      _lastPrediction = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearResults() {
    _selectedImage = null;
    _lastPrediction = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}