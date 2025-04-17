import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini_app/presentation/screens/providers/chat/is_gemini_writing.dart';
import 'package:gemini_app/presentation/screens/providers/users/user_provider.dart';
import 'package:uuid/uuid.dart';

class BasicPromptScreen extends ConsumerWidget {
  const BasicPromptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geminiUser = ref.watch(geminiUserProvider);
    final user = ref.watch(userProvider);
    final isGeminiWriting = ref.watch(isGeminiWritingProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Promp Básico'),
        ),
        body: Chat(
          messages: [
            types.TextMessage(author: user, id: 'Hola 2', text: 'text'),
            types.TextMessage(author: user, id: 'Hola', text: 'text')
          ],
          onSendPressed: (types.PartialText partialText) {
            print(partialText.text);
          },
          user: user,
          theme: const DarkChatTheme(),
          showUserNames: true,
          // showUserAvatars: true,
          typingIndicatorOptions: TypingIndicatorOptions(
              typingUsers: isGeminiWriting ? [geminiUser] : [],
              customTypingWidget: const Center(
                child: Text('Gemini esta pensando...'),
              )),
        ));
  }
}
