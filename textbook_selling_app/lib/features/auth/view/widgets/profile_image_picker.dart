import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/widgets/outline_button.dart';
import 'package:textbook_selling_app/features/auth/viewmodel/register_viewmodel.dart';

class ProfileImagePicker extends ConsumerWidget {
  const ProfileImagePicker({
    super.key,
    required this.onPickImageFromCamera,
    required this.onPickImageFromGallery,
    required this.onRemoveImage,
  });

  final void Function() onPickImageFromCamera;
  final void Function() onPickImageFromGallery;
  final void Function() onRemoveImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickedImageFile =
        ref.watch(registerViewModelProvider).pickedImageFile;
    var imagePath = pickedImageFile != null ? pickedImageFile.path : '';

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.transparent,
                  foregroundImage:
                      imagePath != '' ? FileImage(pickedImageFile!) : null,
                  child: imagePath == ''
                      ? Icon(
                          Icons.person_2_rounded,
                          size: 50,
                          color: Theme.of(context).colorScheme.onSurface,
                        )
                      : null,
                ),
              ),
              // Icon for removing the image
              if (imagePath != '')
                Positioned(
                  top: -5,
                  right: -5,
                  child: GestureDetector(
                    onTap: onRemoveImage,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Icon(
                        Icons.clear,
                        size: 16,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          // Button for opening the camera
          CustomOutlinedButton(
            onPressed: onPickImageFromCamera,
            icon: Icon(
              Icons.camera_alt_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            label: 'Take picture',
          ),
          const SizedBox(width: 10),
          // Button for opening the gallery
          CustomOutlinedButton(
            onPressed: onPickImageFromGallery,
            icon: Icon(
              Icons.image,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            label: 'Choose image',
          ),
        ],
      ),
    );
  }
}
