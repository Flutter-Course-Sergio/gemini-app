import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Gemini'),
        ),
        body: ListView(
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.pink,
                child: Icon(Icons.percent_outlined),
              ),
              title: const Text('Prompt básico de Gemini'),
              subtitle: const Text('Usando un modelo flash'),
              onTap: () => context.push('/basic-prompt'),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.history_outlined),
              ),
              title: const Text('Contexto conversacional'),
              subtitle: const Text('Mantener el contexto de mensajes'),
              onTap: () => context.push('/history-chat'),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.image_outlined),
              ),
              title: const Text('Generación de imágenes'),
              subtitle: const Text('Crea y edita impagenes con AI'),
              onTap: () => context.push('/image-playground'),
            )
          ],
        ));
  }
}
