import '../../core/domain/entities/message.dart';
import '../../core/domain/interfaces/conversation_storage_interface.dart';

class MemoryConversationStorage implements ConversationStorageInterface {
  List<Message> _storage = [];

  @override
  Future<void> save(List<Message> messages) async {
    _storage = List.from(messages);
  }

  @override
  Future<List<Message>> load() async {
    return List.from(_storage);
  }
}