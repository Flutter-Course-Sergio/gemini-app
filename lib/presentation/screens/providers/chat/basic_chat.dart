import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:gemini_app/config/gemini/gemini_impl.dart';
import 'package:gemini_app/presentation/screens/providers/chat/is_gemini_writing.dart';
import 'package:gemini_app/presentation/screens/providers/users/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'basic_chat.g.dart';

const uuid = Uuid();

@riverpod
class BasicChat extends _$BasicChat {
  final gemini = GeminiImpl();
  late User geminiUser;

  @override
  List<Message> build() {
    geminiUser = ref.read(geminiUserProvider);
    return [];
  }

  void addMessage({
    required PartialText partialText,
    required User user,
  }) {
    // TODO: agregar condición cuando vengan imágenes
    _addTextMessage(partialText, user);
  }

  void _addTextMessage(PartialText partialText, User author) {
    _createTextMessage(partialText.text, author);
    _geminiTextResponse(partialText.text);
  }

  void _geminiTextResponse(String prompt) async {
    _setGeminiWritingStatus(true);

    final response = await gemini.getResponse(prompt);

    _setGeminiWritingStatus(false);

    _createTextMessage(response, geminiUser);
  }

// Helper methods
  void _setGeminiWritingStatus(bool isWriting) {
    final isGeminiWriting = ref.read(isGeminiWritingProvider.notifier);
    isWriting
        ? isGeminiWriting.setIsWriting()
        : isGeminiWriting.setIsNotWriting();
  }

  void _createTextMessage(String text, User author) {
    final message = TextMessage(
        author: author,
        id: uuid.v4(),
        text: text,
        createdAt: DateTime.now().microsecondsSinceEpoch);

    state = [message, ...state];
  }
}
