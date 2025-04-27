import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini_app/presentation/providers/chat/basic_chat.dart';
import 'package:gemini_app/presentation/providers/chat/is_gemini_writing.dart';
import 'package:gemini_app/presentation/providers/users/user_provider.dart';
import 'package:gemini_app/presentation/widgets/chat/custom_bottom_input.dart';
import 'package:image_picker/image_picker.dart';

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
          title: const Text('Prompt Básico'),
        ),
        body: Chat(
          messages: chatMessages,
          // On Send Message
          onSendPressed: (types.PartialText partialText) {},
          user: user,
          theme: const DarkChatTheme(),
          showUserNames: true,
          // Custom Input Area
          customBottomWidget: CustomBottomInput(
            onSend: (partialText, {images = const []}) {
              final basicChatNotifier = ref.read(basicChatProvider.notifier);
              basicChatNotifier.addMessage(
                  partialText: partialText, user: user);
            },
          ),
          typingIndicatorOptions: TypingIndicatorOptions(
              typingUsers: isGeminiWriting ? [geminiUser] : [],
              customTypingWidget: const Center(
                child: Text('Gemini esta pensando...'),
              )),
        ));
  }
}
