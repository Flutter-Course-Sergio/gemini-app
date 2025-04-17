import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini_app/presentation/screens/providers/chat/basic_chat.dart';
import 'package:gemini_app/presentation/screens/providers/chat/is_gemini_writing.dart';
import 'package:gemini_app/presentation/screens/providers/users/user_provider.dart';

class BasicPromptScreen extends ConsumerWidget {
  const BasicPromptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geminiUser = ref.watch(geminiUserProvider);
    final user = ref.watch(userProvider);
    final isGeminiWriting = ref.watch(isGeminiWritingProvider);
    final chatMessages = ref.watch(basicChatProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Promp Básico'),
        ),
        body: Chat(
          messages: chatMessages,
          onSendPressed: (types.PartialText partialText) {
            final basicChatNotifier = ref.read(basicChatProvider.notifier);
            basicChatNotifier.addMessage(partialText: partialText, user: user);
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
