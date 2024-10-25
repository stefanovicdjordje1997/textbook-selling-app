import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGalleryViewModel extends StateNotifier<List<XFile>> {
  PhotoGalleryViewModel() : super([]);

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImages() async {
    final List<XFile> pickedImages = await _picker.pickMultiImage();
    if (pickedImages.isNotEmpty && state.length + pickedImages.length <= 6) {
      state = [...state, ...pickedImages];
    }
  }

  Future<void> takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null && state.length < 6) {
      state = [...state, image];
    }
  }

  void removeImage(XFile image) {
    state = [...state.where((img) => img.path != image.path)];
  }

  void reorderImages(int oldIndex, int newIndex) {
    if (newIndex >= state.length) {
      newIndex = state.length - 1;
    }
    if (oldIndex < 0 || oldIndex >= state.length) return;

    final List<XFile> newImages = List.from(state);
    final XFile movedImage = newImages.removeAt(oldIndex);
    newImages.insert(newIndex, movedImage);
    state = newImages;
  }
}

final photoGalleryProvider =
    StateNotifierProvider<PhotoGalleryViewModel, List<XFile>>((ref) {
  return PhotoGalleryViewModel();
});
