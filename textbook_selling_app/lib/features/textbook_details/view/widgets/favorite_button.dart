import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
  });

  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
