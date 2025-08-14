class DiseasePrediction {
  final String predictedClass;
  final double confidence;
  final bool isConfident;
  final double confidenceThreshold;
  final Map<String, double> allProbabilities;
  final String filename;
  final String timestamp;

  DiseasePrediction({
    required this.predictedClass,
    required this.confidence,
    required this.isConfident,
    required this.confidenceThreshold,
    required this.allProbabilities,
    required this.filename,
    required this.timestamp,
  });

  factory DiseasePrediction.fromJson(Map<String, dynamic> json) {
    return DiseasePrediction(
      predictedClass: json['prediction']['predicted_class'],
      confidence: json['prediction']['confidence'].toDouble(),
      isConfident: json['prediction']['is_confident'],
      confidenceThreshold: json['prediction']['confidence_threshold'].toDouble(),
      allProbabilities: Map<String, double>.from(
        json['all_probabilities'].map((key, value) => MapEntry(key, value.toDouble())),
      ),
      filename: json['filename'],
      timestamp: json['timestamp'],
    );
  }

  String get diseaseNameInSpanish {
    switch (predictedClass) {
      case 'Bacterial spot':
        return 'Mancha bacteriana';
      case 'Early blight':
        return 'Tizón temprano';
      case 'Late blight':
        return 'Tizón tardío';
      case 'Leaf mold':
        return 'Moho de la hoja';
      case 'Septoria leaf spot':
        return 'Mancha foliar por Septoria';
      case 'Healthy':
        return 'Saludable';
      default:
        return predictedClass;
    }
  }

  String get confidencePercentage => '${(confidence * 100).toStringAsFixed(1)}%';
}