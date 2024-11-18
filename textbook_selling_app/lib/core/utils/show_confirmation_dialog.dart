import 'package:flutter/material.dart';
import 'package:textbook_selling_app/core/widgets/confirmation_dialog.dart';

Future<void> showConfirmationDialog(BuildContext context, String title,
    String message, Future<void> Function() onConfirm) async {
  showDialog(
    context: context,
    barrierDismissible: false, // Zabrani zatvaranje dijaloga van dijaloga
    builder: (BuildContext context) {
      return ConfirmationDialog(
        title: title,
        message: message,
        onConfirm: () async {
          await onConfirm(); // Poziva funkciju za potvrdu
          Navigator.of(context)
              .pop(); // Zatvori dijalog nakon što je akcija završena
        },
      );
    },
  );
}
