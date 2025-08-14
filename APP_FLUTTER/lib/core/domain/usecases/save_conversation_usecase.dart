import '../interfaces/conversation_storage_interface.dart';
import '../entities/message.dart';

class SaveConversationUseCase {
  final ConversationStorageInterface storage;

  SaveConversationUseCase(this.storage);

  Future<void> execute(List<Message> messages) async {
    await storage.save(messages);
  }
}