import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pry_final/adapters/ui/home_screen.dart';
import 'package:pry_final/application/chatbot_controller.dart';
import 'package:pry_final/application/disease_detection_controller.dart';
import 'package:pry_final/core/domain/usecases/send_message_usecase.dart';
import 'package:pry_final/core/domain/usecases/detect_disease_usecase.dart';
import 'package:pry_final/infrastructure/services/ollama_chat_service.dart';
import 'package:pry_final/infrastructure/services/tomato_disease_api_service.dart';
import 'package:pry_final/infrastructure/services/memory_conversation_storage.dart';
import 'package:pry_final/core/domain/usecases/save_conversation_usecase.dart';
import 'package:pry_final/infrastructure/services/shared_preferences_conversation_storage.dart';
import 'package:pry_final/theme/app_themes.dart';
import 'package:pry_final/theme/theme_manager.dart';
import 'package:pry_final/adapters/ui/widgets/app_background.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Chatbot dependencies
  final chatbot = OllamaChatService();
  final chatUsecase = SendMessageUseCase(chatbot);
  final storage = SharedPreferencesConversationStorage();
  final saveUsecase = SaveConversationUseCase(storage);
  final chatController = ChatbotController(chatUsecase, saveUsecase, storage);
  
  // Disease detection dependencies
  final diseaseApi = TomatoDiseaseApiService();
  final detectUsecase = DetectDiseaseUseCase(diseaseApi);
  final diseaseController = DiseaseDetectionController(detectUsecase);
  
  // Theme manager
  final themeManager = ThemeManager();
  
  await chatController.init();
  
  runApp(MyApp(
    chatController: chatController,
    diseaseController: diseaseController,
    themeManager: themeManager,
  ));
}

class MyApp extends StatelessWidget {
  final ChatbotController chatController;
  final DiseaseDetectionController diseaseController;
  final ThemeManager themeManager;

  const MyApp({
    super.key,
    required this.chatController,
    required this.diseaseController,
    required this.themeManager,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeManager),
        ChangeNotifierProvider.value(value: diseaseController),
      ],
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          return MaterialApp(
            title: 'Asistente Agrícola  🤖🌱',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeManager.themeMode,
            home: AppBackground(
              child: HomeScreen(
                chatbotController: chatController,
                diseaseController: diseaseController,
              ),
            ),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
