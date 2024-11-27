// Show loader with fade animation
import 'package:flutter/material.dart';
import 'package:textbook_selling_app/core/widgets/loader.dart';

// Function to show the loader
void showLoader(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Loader(backgroundDimPercentage: 0.5);
    },
  );
}

// Function to hide the loader
void hideLoader(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }
}
