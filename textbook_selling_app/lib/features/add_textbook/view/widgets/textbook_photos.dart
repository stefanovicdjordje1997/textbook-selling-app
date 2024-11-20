import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constants/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/widgets/card.dart';
import 'package:textbook_selling_app/core/widgets/photo_gallery.dart';
import 'package:textbook_selling_app/features/add_textbook/view/screens/add_textbook.dart';
import 'package:textbook_selling_app/features/add_textbook/viewmodel/add_textbook_viewmodel.dart';

class TextbookPhotos extends ConsumerWidget {
  const TextbookPhotos({
    super.key,
    required this.mode,
  });

  final TextbookMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textbook = ref.watch(addTextbookViewModelProvider).textbook;

    return CustomCard(
      title: AppLocalizations.getString(LocalKeys.textbookPhotosTitle),
      children: [
        PhotoGallery(
          onImageAdded: (image) {},
          onImageRemoved: (image) {},
          images: textbook != null ? textbook.imageUrls : const [],
          mode: mode,
        ),
      ],
    );
  }
}
