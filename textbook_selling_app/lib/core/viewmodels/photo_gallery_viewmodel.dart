import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textbook_selling_app/core/constants/local_keys.dart';
import 'package:textbook_selling_app/core/repository/image_repository.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';

class PhotoGalleryViewModel extends StateNotifier<PhotoGalleryState> {
  PhotoGalleryViewModel() : super(PhotoGalleryState(images: []));

  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImages() async {
    final List<XFile> pickedImages = await _picker.pickMultiImage();
    final isPickedMoreThanMax = state.images.length + pickedImages.length > 6;

    if (isPickedMoreThanMax) {
      return AppLocalizations.getString(LocalKeys.imageLimitMessage);
    } else {
      if (pickedImages.isNotEmpty) {
        for (var image in pickedImages) {
          ImageRepository.addImage(image);
        }
        state = state.copyWith(images: [...state.images, ...pickedImages]);
      }
      return null; // No message, indicating success
    }
  }

  Future<void> takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null && state.images.length < 6) {
      ImageRepository.addImage(image);
      state = state.copyWith(images: [...state.images, image]);
    }
  }

  void removeImage(XFile image) {
    ImageRepository.removeImage(image);
    state = state.copyWith(
      images: [...state.images.where((img) => img.path != image.path)],
    );
  }

  void onPageChanged(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void onHoldImage(int index) {
    state = state.copyWith(
      isReordering: state.images.length > 1,
      selectedImageIndex: index,
    );
  }

  void doneReordering() {
    ImageRepository.setImages(state.images);
    state = state.copyWith(
      isReordering: false,
      selectedImageIndex: null,
    );
  }

  void reorderImages(int oldIndex, int newIndex) {
    if (newIndex >= state.images.length) {
      newIndex = state.images.length - 1;
    }
    if (oldIndex < 0 || oldIndex >= state.images.length) return;

    final List<XFile> newImages = List.from(state.images);
    final XFile movedImage = newImages.removeAt(oldIndex);
    newImages.insert(newIndex, movedImage);
    state = state.copyWith(images: newImages);
  }

  void moveImage(int direction, PageController pageController) {
    if (state.selectedImageIndex != null) {
      final newIndex = state.selectedImageIndex! + direction;
      if (newIndex >= 0 && newIndex < state.images.length) {
        reorderImages(state.selectedImageIndex!, newIndex);
        state = state.copyWith(selectedImageIndex: newIndex);
        pageController.jumpToPage(state.selectedImageIndex!);
      }
    }
  }
}

class PhotoGalleryState {
  final List<XFile> images;
  final int currentIndex;
  final bool isReordering;
  final int? selectedImageIndex;

  PhotoGalleryState({
    required this.images,
    this.currentIndex = 0,
    this.isReordering = false,
    this.selectedImageIndex,
  });

  PhotoGalleryState copyWith({
    List<XFile>? images,
    int? currentIndex,
    bool? isReordering,
    int? selectedImageIndex,
  }) {
    return PhotoGalleryState(
      images: images ?? this.images,
      currentIndex: currentIndex ?? this.currentIndex,
      isReordering: isReordering ?? this.isReordering,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
    );
  }
}

final photoGalleryProvider =
    StateNotifierProvider<PhotoGalleryViewModel, PhotoGalleryState>((ref) {
  return PhotoGalleryViewModel();
});
