import 'package:flutter/material.dart';

class BasicPromptScreen extends StatelessWidget {
  const BasicPromptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic'),
      ),
      body: const Center(
        child: Text('Basic Prompt Screen'),
      ),
    );
  }
}
