import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textbook_selling_app/core/widgets/outline_button.dart';

class PhotoGallery extends StatefulWidget {
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
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  late List<XFile> images;
  final ImagePicker _picker = ImagePicker();
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isReordering = false;
  int? _selectedImageIndex;

  @override
  void initState() {
    super.initState();
    images = widget.images; // Initialize the image list
  }

  void _pickImages() async {
    final List<XFile> pickedImages = await _picker.pickMultiImage();

    if (images.length + pickedImages.length <= 6) {
      setState(() {
        for (var image in pickedImages) {
          widget.onImageAdded(image);
          images.add(image);
        }
      });
    }
  }

  void _takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null && images.length < 6) {
      setState(() {
        widget.onImageAdded(image);
        images.add(image);
      });
    }
  }

  void _removeImage(XFile image) {
    widget.onImageRemoved(image);
    setState(() {
      images.remove(image);

      // Ensure current index stays within bounds after deletion
      if (_currentIndex >= images.length) {
        _currentIndex = images.isNotEmpty ? images.length - 1 : 0;
      }

      _pageController.jumpToPage(_currentIndex);
    });
  }

  void _onHoldImage(int index) {
    setState(() {
      _isReordering = images.length > 1;
      _selectedImageIndex = index;
    });
  }

  void _moveImage(int direction) {
    if (_selectedImageIndex != null) {
      final newIndex = _selectedImageIndex! + direction;
      if (newIndex >= 0 && newIndex < images.length) {
        setState(() {
          final temp = images[_selectedImageIndex!];
          images[_selectedImageIndex!] = images[newIndex];
          images[newIndex] = temp;
          _selectedImageIndex = newIndex;
          _pageController.jumpToPage(_selectedImageIndex!);
        });
      }
    }
  }

  void _doneReordering() {
    setState(() {
      _isReordering = false;
      _selectedImageIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    physics: _isReordering
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final image = images[index];
                      return GestureDetector(
                        onLongPress: () => _onHoldImage(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow:
                                _isReordering && _selectedImageIndex == index
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
                                if (!_isReordering)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => _removeImage(image),
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
                if (_isReordering)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: _selectedImageIndex != null &&
                                _selectedImageIndex! > 0
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.end,
                        children: [
                          if (_selectedImageIndex != null &&
                              _selectedImageIndex! > 0)
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
                              onPressed: () => _moveImage(-1), // Move left
                            ),
                          if (_selectedImageIndex != null &&
                              _selectedImageIndex! < images.length - 1)
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
                              onPressed: () => _moveImage(1), // Move right
                            ),
                        ],
                      ),
                    ),
                  ),
                if (_isReordering)
                  Positioned(
                    left: 100,
                    right: 100,
                    bottom: 10,
                    child: ElevatedButton(
                      onPressed: _doneReordering,
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
                width: _currentIndex == index ? 12 : 10,
                height: _currentIndex == index ? 12 : 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          // Buttons to add images
          !_isReordering
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomOutlinedButton(
                      onPressed: images.length < 6 ? _takePicture : null,
                      icon: const Icon(Icons.camera_alt),
                      label: 'Take Picture',
                    ),
                    CustomOutlinedButton(
                      onPressed: images.length < 6 ? _pickImages : null,
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
