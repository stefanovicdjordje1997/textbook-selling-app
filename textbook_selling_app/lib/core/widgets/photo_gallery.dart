import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textbook_selling_app/core/utils/snack_bar.dart';
import 'package:textbook_selling_app/core/viewmodels/photo_gallery_viewmodel.dart';
import 'package:textbook_selling_app/core/widgets/outline_button.dart';

class PhotoGallery extends ConsumerStatefulWidget {
  const PhotoGallery({
    super.key,
    required this.onImageAdded,
    required this.onImageRemoved,
    required this.images,
  });

  final List<XFile> images;
  final Function(XFile) onImageAdded;
  final Function(XFile) onImageRemoved;

  @override
  ConsumerState<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends ConsumerState<PhotoGallery> {
  final PageController _pageController = PageController();

  // @override
  // void initState() {
  //   super.initState();
  //   images = widget.images; // Initialize the image list
  // }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(photoGalleryProvider.notifier);
    final images = ref.watch(photoGalleryProvider).images;
    final currentIndex = ref.watch(photoGalleryProvider).currentIndex;
    final isReordering = ref.watch(photoGalleryProvider).isReordering;
    final selectedImageIndex =
        ref.watch(photoGalleryProvider).selectedImageIndex;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 400,
            width: 300,
            child: Stack(
              children: [
                // Show image and message when there are no images
                if (images.isEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_rounded,
                          size: 70,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.8),
                        ),
                        const SizedBox(
                            height: 10), // Adds space between icon and text
                        const Text('No photos'),
                        const SizedBox(height: 5),
                        Text(
                          "The first image will appear as the cover photo on the listing. To reorder images, hold on any image to access the options.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.5)),
                        ),
                      ],
                    ),
                  ),
                // Show PageView if images exist
                if (images.isNotEmpty)
                  PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    physics: isReordering
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
                    onPageChanged: viewModel.onPageChanged,
                    itemBuilder: (context, index) {
                      final image = images[index];
                      return GestureDetector(
                        onLongPress: () => viewModel.onHoldImage(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow:
                                isReordering && selectedImageIndex == index
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          offset: const Offset(0, 2),
                                          blurRadius: 5,
                                        ),
                                      ]
                                    : [],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                Image.file(
                                  File(image.path),
                                  fit: BoxFit.cover,
                                ),
                                if (!isReordering)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => viewModel.removeImage(image),
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.8),
                                        child: Icon(
                                          Icons.close,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                // Icon to mark the cover photo
                                if (index == 0)
                                  Positioned(
                                    top: 8,
                                    left: 6,
                                    child: Icon(
                                      Icons.add_to_home_screen_rounded,
                                      size: 30,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.8),
                                      shadows: const [
                                        Shadow(
                                            color: Colors.black54,
                                            offset: Offset(2, 2),
                                            blurRadius: 10.0),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                // Arrows and "Done" button during reordering
                if (isReordering)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment:
                            selectedImageIndex != null && selectedImageIndex > 0
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.end,
                        children: [
                          if (selectedImageIndex != null &&
                              selectedImageIndex > 0)
                            IconButton(
                              icon: Icon(
                                Icons.arrow_left,
                                size: 70,
                                color: Theme.of(context).colorScheme.surface,
                                shadows: [
                                  Shadow(
                                      offset: const Offset(2, 2),
                                      blurRadius: 8.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface)
                                ],
                              ),
                              onPressed: () => viewModel.moveImage(
                                  -1, _pageController), // Move left
                            ),
                          if (selectedImageIndex != null &&
                              selectedImageIndex < images.length - 1)
                            IconButton(
                              icon: Icon(
                                Icons.arrow_right,
                                size: 70,
                                color: Theme.of(context).colorScheme.surface,
                                shadows: [
                                  Shadow(
                                      offset: const Offset(2, 2),
                                      blurRadius: 8.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface)
                                ],
                              ),
                              onPressed: () => viewModel.moveImage(
                                  1, _pageController), // Move right
                            ),
                        ],
                      ),
                    ),
                  ),
                if (isReordering)
                  Positioned(
                    left: 100,
                    right: 100,
                    bottom: 10,
                    child: ElevatedButton(
                      onPressed: viewModel.doneReordering,
                      child: const Text('Done'),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Indicator dots for current image
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentIndex == index ? 12 : 10,
                height: currentIndex == index ? 12 : 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          // Buttons to add images
          !isReordering
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomOutlinedButton(
                      onPressed:
                          images.length < 6 ? viewModel.takePicture : null,
                      icon: const Icon(Icons.camera_alt),
                      label: 'Take Picture',
                    ),
                    CustomOutlinedButton(
                      onPressed: images.length < 6
                          ? () async {
                              final message = await viewModel.pickImages();
                              if (message != null) {
                                if (context.mounted) {
                                  showSnackBar(
                                      context: context,
                                      message: message,
                                      type: SnackBarType.error);
                                }
                              }
                            }
                          : null,
                      icon: const Icon(Icons.photo),
                      label: 'Pick from Gallery',
                    ),
                  ],
                )
              : const Text(
                  'Use arrows to change the order of the photo.',
                  textAlign: TextAlign.center,
                ),
        ],
      ),
    );
  }
}
