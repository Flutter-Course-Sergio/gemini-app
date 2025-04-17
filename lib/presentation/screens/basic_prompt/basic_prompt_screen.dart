import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

const user = types.User(
    id: 'user-id-abc',
    firstName: 'Sergio',
    lastName: 'Barreras',
    imageUrl: 'https://picsum.photos/id/177/200/200');

const geminiUser = types.User(
    id: 'gemini-id',
    firstName: 'Gemini',
    imageUrl: 'https://picsum.photos/id/179/200/200');

final messages = <types.Message>[
  types.TextMessage(author: user, id: Uuid().v4(), text: 'Hola mundo'),
  types.TextMessage(author: geminiUser, id: Uuid().v4(), text: 'Hola Sergio'),
];

class BasicPromptScreen extends StatelessWidget {
  const BasicPromptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Promp Básico'),
        ),
        body: Chat(
          messages: messages,
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
