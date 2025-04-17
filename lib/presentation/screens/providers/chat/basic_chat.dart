import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'basic_chat.g.dart';

const uuid = Uuid();

@riverpod
class BasicChat extends _$BasicChat {
  @override
  List<Message> build() {
    return [];
  }

  void addMessage({
    required PartialText partialText,
    required User user,
  }) {
    _addTextMessage(partialText, user);
  }

  void _addTextMessage(PartialText partialText, User author) {
    final message = TextMessage(
        author: author,
        id: uuid.v4(),
        text: partialText.text,
        createdAt: DateTime.now().microsecondsSinceEpoch);

    state = [message, ...state];
  }
}
