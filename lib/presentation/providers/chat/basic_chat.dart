import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:gemini_app/config/gemini/gemini_impl.dart';
import 'package:gemini_app/presentation/providers/chat/is_gemini_writing.dart';
import 'package:gemini_app/presentation/providers/users/user_provider.dart';
import 'package:image_picker/image_picker.dart';
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

  void addMessage(
      {required PartialText partialText,
      required User user,
      List<XFile> images = const []}) {
    if (images.isNotEmpty) {
      _addTextMessageWithImages(partialText, user, images);
      return;
    }

    _addTextMessage(partialText, user);
  }

  void _addTextMessage(PartialText partialText, User author) {
    _createTextMessage(partialText.text, author);
    _geminiTextResponseStream(partialText.text);
  }

  void _addTextMessageWithImages(
      PartialText partialText, User author, List<XFile> images) async {
    for (XFile image in images) {
      _createImageMessage(image, author);
    }

    await Future.delayed(const Duration(milliseconds: 10));

    _createTextMessage(partialText.text, author);
    _geminiTextResponseStream(partialText.text, files: images);
  }

  void _geminiTextResponse(String prompt) async {
    _setGeminiWritingStatus(true);

    final response = await gemini.getResponse(prompt);

    _setGeminiWritingStatus(false);

    _createTextMessage(response, geminiUser);
  }

  void _geminiTextResponseStream(String prompt,
      {List<XFile> files = const []}) async {
    _createTextMessage('Gemini está pensando...', geminiUser);

    gemini.getResponseStream(prompt, files: files).listen((responseChunk) {
      if (responseChunk.isEmpty) return;

      final updatedMessages = [...state];
      final updatedMessage =
          (updatedMessages.first as TextMessage).copyWith(text: responseChunk);

      updatedMessages[0] = updatedMessage;
      state = updatedMessages;
    });
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

  Future<void> _createImageMessage(XFile image, User author) async {
    final message = ImageMessage(
        id: uuid.v4(),
        author: author,
        uri: image.path,
        name: image.name,
        size: await image.length(),
        createdAt: DateTime.now().microsecondsSinceEpoch);

    state = [message, ...state];
  }
}
