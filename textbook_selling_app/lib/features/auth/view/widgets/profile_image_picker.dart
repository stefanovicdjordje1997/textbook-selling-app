import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/widgets/outline_button.dart';
import 'package:textbook_selling_app/features/auth/viewmodel/register_viewmodel.dart';

class ProfileImagePicker extends ConsumerWidget {
  const ProfileImagePicker({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickedImageFile =
        ref.watch(registerViewModelProvider).pickedImageFile;
    final registerViewModel = ref.read(registerViewModelProvider.notifier);

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
                  foregroundImage: pickedImageFile != null
                      ? FileImage(pickedImageFile)
                      : null,
                  child: pickedImageFile == null
                      ? Icon(
                          Icons.person_2_rounded,
                          size: 50,
                          color: Theme.of(context).colorScheme.onSurface,
                        )
                      : null,
                ),
              ),
              // Ikona za brisanje slike (X) u gornjem desnom uglu
              if (pickedImageFile != null)
                Positioned(
                  top: -5,
                  right: -5,
                  child: GestureDetector(
                    onTap: registerViewModel.removeImage,
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
          // Dugme za snimanje slike kamere
          CustomOutlinedButton(
            onPressed: registerViewModel.pickImageFromCamera,
            icon: Icon(
              Icons.camera_alt_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            label: 'Take picture',
          ),
          const SizedBox(width: 10),
          // Dugme za izbor slike iz galerije
          CustomOutlinedButton(
            onPressed: registerViewModel.pickImageFromGallery,
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
