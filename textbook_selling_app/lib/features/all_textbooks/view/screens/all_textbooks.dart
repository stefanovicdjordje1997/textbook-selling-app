import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/widgets/textbook_card.dart';
import 'package:textbook_selling_app/features/all_textbooks/viewmodel/all_textbooks_viewmodel.dart';

class AllTextbooksScreen extends ConsumerStatefulWidget {
  const AllTextbooksScreen({super.key});

  @override
  ConsumerState<AllTextbooksScreen> createState() => _AllTextbooksScreenState();
}

class _AllTextbooksScreenState extends ConsumerState<AllTextbooksScreen> {
  @override
  void initState() {
    super.initState();
    // Initiates loading of textbooks when the widget is created
    Future.microtask(() {
      if (context.mounted && ref.read(allTextbooksProvider).textbooks == null) {
        ref.read(allTextbooksProvider.notifier).getAllTextbooks(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watches the textbook list from the provider
    final viewModel = ref.watch(allTextbooksProvider.notifier);
    final textbooks = ref.watch(allTextbooksProvider).textbooks;

    return Scaffold(
        body: textbooks != null
            ? RefreshIndicator(
                onRefresh: () => viewModel.getAllTextbooks(context),
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 16, bottom: 30),
                  itemCount: textbooks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: TextbookCard(
                        textbook: textbooks[index],
                        onTap: () {
                          // Define action on tap, e.g., navigate to details page
                        },
                      ),
                    );
                  },
                ),
              )
            : null);
  }
}
