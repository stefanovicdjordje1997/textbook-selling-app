import 'package:image_picker/image_picker.dart';

class ImageRepository {
  static List<XFile> _images = [];

  static List<XFile> get images =>
      List.unmodifiable(_images); // Read-only access

  static void addImage(XFile image) {
    if (_images.length < 6) {
      _images.add(image);
    }
  }

  static void removeImage(XFile image) {
    _images.removeWhere((img) => img.path == image.path);
  }

  static void setImages(List<XFile> images) {
    _images = images;
  }

  static void clearImages() {
    _images.clear();
  }
}
