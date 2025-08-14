import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/disease_detection_controller.dart';
import '../../theme/theme_manager.dart';
import '../../theme/color_palette.dart';
import 'widgets/app_background.dart';

class DiseaseDetectionScreen extends StatelessWidget {
  final DiseaseDetectionController controller;

  const DiseaseDetectionScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer2<DiseaseDetectionController, ThemeManager>(
          builder: (context, diseaseController, themeManager, child) {
            final isDark = themeManager.isDarkMode;
            
            return AppBackground(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Información de la funcionalidad
                    Card(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: isDark ? darkCardGradient : lightCardGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.agriculture,
                              size: 48,
                              color: isDark ? verdeMenta : azulVibrante,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Análisis de Enfermedades en Tomate',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? modernDarkText : modernLightText,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Toma una foto de una hoja de tomate para detectar posibles enfermedades',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? modernDarkSecondaryText : modernLightSecondaryText,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Botones de captura
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: isDark ? primaryGradientDark : primaryGradientLight,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: diseaseController.isLoading 
                                  ? null 
                                  : () => diseaseController.pickImageFromCamera(),
                              icon: const Icon(Icons.camera_alt, color: Colors.white),
                              label: const Text('Cámara', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: isDark ? accentGradientDark : accentGradientLight,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: diseaseController.isLoading 
                                  ? null 
                                  : () => diseaseController.pickImageFromGallery(),
                              icon: const Icon(Icons.photo_library, color: Colors.white),
                              label: const Text('Galería', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Imagen seleccionada
                    if (diseaseController.selectedImage != null)
                      Card(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: isDark ? darkCardGradient : lightCardGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  diseaseController.selectedImage!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: isDark ? primaryGradientDark : primaryGradientLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: diseaseController.isLoading 
                                        ? null 
                                        : () => diseaseController.detectDisease(),
                                    icon: diseaseController.isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : const Icon(Icons.search, color: Colors.white),
                                    label: Text(
                                      diseaseController.isLoading 
                                          ? 'Analizando...' 
                                          : 'Detectar Enfermedad',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Mostrar error
                    if (diseaseController.error != null)
                      Card(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? modernDarkError.withOpacity(0.2) : modernLightError.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark ? modernDarkError : modernLightError,
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: isDark ? modernDarkError : modernLightError,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  diseaseController.error!,
                                  style: TextStyle(
                                    color: isDark ? modernDarkError : modernLightError,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => diseaseController.clearError(),
                                icon: Icon(
                                  Icons.close,
                                  color: isDark ? modernDarkError : modernLightError,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Mostrar resultados
                    if (diseaseController.lastPrediction != null)
                      Card(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: isDark ? darkCardGradient : lightCardGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    diseaseController.lastPrediction!.predictedClass == 'Healthy'
                                        ? Icons.check_circle
                                        : Icons.warning,
                                    color: diseaseController.lastPrediction!.predictedClass == 'Healthy'
                                        ? (isDark ? modernDarkSuccess : modernLightSuccess)
                                        : (isDark ? modernDarkWarning : modernLightWarning),
                                    size: 32,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Resultado del Análisis',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? modernDarkText : modernLightText,
                                          ),
                                        ),
                                        Text(
                                          diseaseController.lastPrediction!.diseaseNameInSpanish,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? verdeMenta : azulVibrante,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark 
                                      ? modernDarkPrimary.withOpacity(0.1)
                                      : modernLightPrimary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Confianza:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: isDark ? modernDarkSecondaryText : modernLightSecondaryText,
                                      ),
                                    ),
                                    Text(
                                      diseaseController.lastPrediction!.confidencePercentage,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? modernDarkText : modernLightText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Botón limpiar
                    if (diseaseController.selectedImage != null || diseaseController.lastPrediction != null)
                      OutlinedButton.icon(
                        onPressed: () => diseaseController.clearResults(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Nueva Imagen'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
    );
  }
}