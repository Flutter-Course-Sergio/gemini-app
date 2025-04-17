import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:gemini_app/presentation/screens/providers/chat/is_gemini_writing.dart';
import 'package:gemini_app/presentation/screens/providers/users/user_provider.dart';
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
    _geminiTextResponse(partialText.text);
  }

  void _geminiTextResponse(String prompt) async {
    final isGeminiWriting = ref.read(isGeminiWritingProvider.notifier);
    final geminiUser = ref.read(geminiUserProvider);

    isGeminiWriting.setIsNotWriting();

    await Future.delayed(Duration(seconds: 2));

    final message = TextMessage(
        author: geminiUser,
        id: uuid.v4(),
        text: 'Hola mundo desde Gemini: $prompt',
        createdAt: DateTime.now().microsecondsSinceEpoch);

    isGeminiWriting.setIsNotWriting();

    state = [message, ...state];
  }
}
