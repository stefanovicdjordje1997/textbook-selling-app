import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constants/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/navigation/create_route.dart';
import 'package:textbook_selling_app/core/utils/show_confirmation_dialog.dart';
import 'package:textbook_selling_app/core/widgets/loader.dart';
import 'package:textbook_selling_app/core/widgets/textbook_card.dart';
import 'package:textbook_selling_app/features/add_textbook/view/screens/add_textbook.dart';
import 'package:textbook_selling_app/features/my_textbooks.dart/viewmodel/my_textbooks_viewmodel.dart';
import 'package:textbook_selling_app/features/textbook_details/view/screens/textbook_details.dart';

class MyTextbooksScreen extends ConsumerStatefulWidget {
  const MyTextbooksScreen({super.key});

  @override
  ConsumerState<MyTextbooksScreen> createState() => _UserTextbooksScreenState();
}

class _UserTextbooksScreenState extends ConsumerState<MyTextbooksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userTextbooksProvider.notifier).fetchUserTextbooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userTextbooksProvider);
    final viewModel = ref.watch(userTextbooksProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.getString(LocalKeys.yourAds),
        ),
      ),
      body: state.isLoading
          ? const Loader()
          : state.userTextbooks.isEmpty
              ? Center(
                  child: Text(
                    AppLocalizations.getString(LocalKeys.noMyTextbooksMessage),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 16, bottom: 30),
                  itemCount: state.userTextbooks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: TextbookCard(
                        textbook: state.userTextbooks[index],
                        onTap: () => Navigator.of(context).push(
                          createRoute(
                              page: TextbookDetailsScreen(
                                textbook: state.userTextbooks[index],
                                context: TextbookDetailsContext.myTextbooks,
                                onDelete: (textbook) {
                                  showConfirmationDialog(
                                    context,
                                    AppLocalizations.getString(
                                        LocalKeys.areYouSure),
                                    AppLocalizations.getString(
                                        LocalKeys.deleteConfirmationMessage),
                                    () async {
                                      await viewModel
                                          .removeUserTextbook(textbook);
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  );
                                },
                                onEdit: (textbook) =>
                                    Navigator.of(context).push(
                                  createRoute(
                                    page: AddTextbookScreen(
                                      textbook: textbook,
                                      mode: TextbookMode.editing,
                                    ),
                                    animationType:
                                        RouteAnimationType.slideFromRight,
                                  ),
                                ),
                              ),
                              animationType: RouteAnimationType.slideFromRight),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
