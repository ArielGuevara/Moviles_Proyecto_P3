import 'package:shared_preferences/shared_preferences.dart';
import '../../core/domain/entities/message.dart';
import '../../core/domain/interfaces/conversation_storage_interface.dart';

class SharedPreferencesConversationStorage implements ConversationStorageInterface {
  static const String _key = 'chat_conversation';

  @override
  Future<void> save(List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = messages
        .map((m) => '${m.isUser ? "1" : "0"}|${m.text}')
        .toList();
    await prefs.setStringList(_key, serialized);
  }

  @override
  Future<List<Message>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = prefs.getStringList(_key) ?? [];
    return serialized.map((s) {
      final parts = s.split('|');
      return Message(
        text: parts.length > 1 ? parts[1] : '',
        isUser: parts.isNotEmpty && parts[0] == "1",
      );
    }).toList();
  }
}