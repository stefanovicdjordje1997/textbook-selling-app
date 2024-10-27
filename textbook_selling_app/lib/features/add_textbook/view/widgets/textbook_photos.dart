import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/widgets/card.dart';
import 'package:textbook_selling_app/core/widgets/photo_gallery.dart';

class TextbookPhotos extends ConsumerWidget {
  const TextbookPhotos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomCard(
      title: 'Textbook photos:',
      children: [
        PhotoGallery(
          onImageAdded: (image) {},
          onImageRemoved: (image) {},
          images: const [],
        ),
      ],
    );
  }
}
