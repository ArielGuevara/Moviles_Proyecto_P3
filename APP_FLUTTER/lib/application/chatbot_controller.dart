import '../core/domain/entities/message.dart';
import '../core/domain/usecases/send_message_usecase.dart';

class ChatbotController {
  final SendMessageUseCase sendMessageUseCase;
  final List<Message> messages = [];

  ChatbotController(this.sendMessageUseCase);

  Future<void> send(String prompt) async {
    messages.add(Message(text: prompt, isUser: true));
    final response = await sendMessageUseCase.execute(prompt);
    messages.add(Message(text: response, isUser: false));
  }

  List<Message> get chat => messages;
}
