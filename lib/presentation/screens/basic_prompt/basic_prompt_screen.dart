import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini_app/presentation/screens/providers/user_provider.dart';
import 'package:uuid/uuid.dart';

const user = types.User(
    id: 'user-id-abc',
    firstName: 'Sergio',
    lastName: 'Barreras',
    imageUrl: 'https://picsum.photos/id/177/200/200');

class BasicPromptScreen extends ConsumerWidget {
  const BasicPromptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final geminiUser = ref.watch(geminiUserProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Promp Básico'),
        ),
        body: Chat(
          messages: [],
          onSendPressed: (types.PartialText partialText) {
            print(partialText.text);
          },
          user: user,
          theme: const DarkChatTheme(),
          showUserNames: true,
          // showUserAvatars: true,
          typingIndicatorOptions: TypingIndicatorOptions(
              // typingUsers: [geminiUser], // TODO
              customTypingWidget: const Center(
            child: Text('Gemini esta pensando...'),
          )),
        ));
  }
}
