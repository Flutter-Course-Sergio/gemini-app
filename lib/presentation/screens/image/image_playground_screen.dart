import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini_app/config/theme/app_theme.dart';
import 'package:gemini_app/presentation/providers/image/generated_images_provider.dart';
import 'package:gemini_app/presentation/providers/image/is_generating_provider.dart';
import 'package:gemini_app/presentation/providers/image/selected_art_provider.dart';
import 'package:gemini_app/presentation/widgets/chat/custom_bottom_input.dart';
import 'package:image_picker/image_picker.dart';

const imageArtStyles = [
  'Realista',
  'Acuarela',
  'Dibujo a Lápiz',
  'Arte Digital',
  'Pintura al Óleo',
  'Acuarela',
  'Dibujo al Carboncillo',
  'Ilustración Digital',
  'Estilo Manga',
];

class ImagePlaygroundScreen extends ConsumerWidget {
  const ImagePlaygroundScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Imágenes con Gemini')),
      backgroundColor: seedColor,
      body: Column(
        children: [
          // Espacio para imágenes generadas
          const GeneratedImageGallery(),

          // Selector de estilo de arte
          const ArtStyleSelector(),
          // Llenar el espacio
          Expanded(child: Container()),
          // Espacio para el prompt
          CustomBottomInput(
            onSend: (partialText, {List<XFile> images = const []}) {
              final generatedImagesNotifier =
                  ref.read(generatedImagesProvider.notifier);

              final selectedStyle = ref.read(selectedArtStyleProvider);
              String promptWithStyle = partialText.text;

              generatedImagesNotifier.clearImages();

              if (selectedStyle.isNotEmpty) {
                promptWithStyle =
                    '${partialText.text} con el estilo de $selectedStyle';
              }

              generatedImagesNotifier.generateImage(promptWithStyle,
                  images: images);
            },
          ),
        ],
      ),
    );
  }
}

class GeneratedImageGallery extends ConsumerWidget {
  const GeneratedImageGallery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final generatedImages = ref.watch(generatedImagesProvider);
    final isGenerating = ref.watch(isGeneratingProvider);

    return SizedBox(
      height: 250,
      child: PageView(
        controller: PageController(
          viewportFraction: 0.6, // Muestra 1.5 imágenes en la pantalla
          initialPage: 0,
        ),
        onPageChanged: (index) {
          if (index == generatedImages.length - 1) {
            ref
                .read(generatedImagesProvider.notifier)
                .generateImageWithPreviousPrompt();
          }
        },
        padEnds: true, // Cambiado a true para centrar la primera imagen
        children: [
          //* Placeholder hasta que se genere al menos una imagen
          if (generatedImages.isEmpty && !isGenerating)
            const EmptyPlaceholderImage(),

          //* Aquí iremos colocando las imágenes generadas
          ...generatedImages.map(
            (imageUrl) => GeneratedImage(
              imageUrl: imageUrl,
            ),
          ),

          if (isGenerating) const GeneratingPlaceholderImage(),
        ],
      ),
    );
  }
}

class GeneratedImage extends StatelessWidget {
  final String imageUrl;

  const GeneratedImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 5,
            spreadRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}

class ArtStyleSelector extends ConsumerWidget {
  const ArtStyleSelector({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final selectedArt = ref.watch(selectedArtStyleProvider);

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageArtStyles.length,
        itemBuilder: (context, index) {
          final style = imageArtStyles[index];
          final activeStyle = selectedArt == style
              ? Theme.of(context).colorScheme.primaryContainer
              : null;

          return GestureDetector(
            onTap: () {
              ref.read(selectedArtStyleProvider.notifier).setSelectedArt(style);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Chip(
                label: Text(style),
                backgroundColor: activeStyle,
              ),
            ),
          );
        },
      ),
    );
  }
}

class EmptyPlaceholderImage extends StatelessWidget {
  const EmptyPlaceholderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 5,
            spreadRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 50, color: Colors.white),
          Text('Empieza a generar imágenes'),
        ],
      ),
    );
  }
}

class GeneratingPlaceholderImage extends StatelessWidget {
  const GeneratingPlaceholderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 5,
            spreadRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
          SizedBox(height: 15),
          Text(
            'Generando imagen...',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
