import '../core/domain/entities/message.dart';
import '../core/domain/interfaces/conversation_storage_interface.dart';
import '../core/domain/usecases/send_message_usecase.dart';
import '../core/domain/usecases/save_conversation_usecase.dart';

class ChatbotController {
  final SendMessageUseCase sendMessageUseCase;
  final SaveConversationUseCase saveConversationUseCase;
  final ConversationStorageInterface storage;
  final List<Message> messages = [];

  ChatbotController(this.sendMessageUseCase, this.saveConversationUseCase, this.storage);

  Future<void> init() async {
    final loaded = await storage.load();
    messages.clear();
    messages.addAll(loaded);
  }

  Future<void> send(String prompt) async {
    messages.add(Message(text: prompt, isUser: true));
    final response = await sendMessageUseCase.execute(prompt);
    messages.add(Message(text: response, isUser: false));
    await saveConversationUseCase.execute(messages);
  }

  List<Message> get chat => messages;
}