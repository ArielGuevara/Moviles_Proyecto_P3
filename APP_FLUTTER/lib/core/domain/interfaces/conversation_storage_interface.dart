import 'package:pry_final/core/domain/entities/message.dart';
abstract class ConversationStorageInterface {
  Future<void> save(List<Message> messages);
  Future<List<Message>> load();
}