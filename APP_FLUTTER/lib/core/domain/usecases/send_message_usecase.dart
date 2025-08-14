import '../interfaces/chatbot_interface.dart';

class SendMessageUseCase {
  final ChatbotInterface chatbot;

  SendMessageUseCase(this.chatbot);

  Future<String> execute(String prompt) async {
    return await chatbot.sendMessage(prompt);
  }
}
