import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTextbookScreen extends ConsumerWidget {
  const AddTextbookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Textbook'),
      ),
      body: const Center(
        child: Text('Screen for adding a textbook.'),
      ),
    );
  }
}
