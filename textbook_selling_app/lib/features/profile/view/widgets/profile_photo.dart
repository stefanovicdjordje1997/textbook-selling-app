import 'package:flutter/material.dart';

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({
    super.key,
    required this.imageUrl,
  });

  final String? imageUrl; // Dozvoljeno da bude null

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 4,
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        child: imageUrl == null || imageUrl!.isEmpty
            ? Container(
                width: 120,
                height: 120,
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.image_rounded,
                  size: 60,
                  color: Colors.grey,
                ),
              )
            : Ink.image(
                image: NetworkImage(imageUrl!),
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
