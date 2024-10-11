import 'package:flutter/material.dart';

enum SnackBarType { success, error, info }

void showCustomSnackBar(
    {required BuildContext context,
    required String message,
    required SnackBarType type}) {
  Color backgroundColor;
  Color textColor;
  IconData icon;

  // Set color and icon based on type
  switch (type) {
    case SnackBarType.success:
      backgroundColor = Theme.of(context).colorScheme.primary;
      textColor = Theme.of(context).colorScheme.onPrimary;
      icon = Icons.check_circle;
      break;
    case SnackBarType.error:
      backgroundColor = Theme.of(context).colorScheme.error;
      textColor = Theme.of(context).colorScheme.onError;
      icon = Icons.error;
      break;
    case SnackBarType.info:
    default:
      backgroundColor = Theme.of(context).colorScheme.secondary;
      textColor = Theme.of(context).colorScheme.onSecondary;
      icon = Icons.info;
  }

  // Create SnackBar
  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(icon, color: textColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: TextStyle(color: textColor),
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, color: textColor),
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ],
    ),
    backgroundColor: backgroundColor,
    duration: const Duration(seconds: 5),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );

  // Prikazujemo SnackBar
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
