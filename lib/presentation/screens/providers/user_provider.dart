import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
User geminiUser(Ref ref) {
  const geminiUser = User(
      id: 'gemini-id',
      firstName: 'Gemini',
      imageUrl: 'https://picsum.photos/id/179/200/200');

  return geminiUser;
}
