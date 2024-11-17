import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constant/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/navigation/create_route.dart';
import 'package:textbook_selling_app/core/widgets/loader.dart';
import 'package:textbook_selling_app/core/widgets/textbook_card.dart';
import 'package:textbook_selling_app/features/favorite_textbooks/viewmodel/favorite_textbooks_viewmodel.dart';
import 'package:textbook_selling_app/features/textbook_details/view/screens/textbook_details.dart';

class FavoriteTextbooksScreen extends ConsumerStatefulWidget {
  const FavoriteTextbooksScreen({super.key});

  @override
  ConsumerState<FavoriteTextbooksScreen> createState() =>
      _FavoriteTextbooksScreenState();
}

class _FavoriteTextbooksScreenState
    extends ConsumerState<FavoriteTextbooksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favoriteTextbooksProvider.notifier).fetchFavoriteTextbooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(favoriteTextbooksProvider);
    final viewModel = ref.watch(favoriteTextbooksProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.getString(LocalKeys.favorites),
        ),
      ),
      body: state.isLoading
          ? const Loader()
          : state.favoriteTextbooks.isEmpty
              ? const Center(
                  child: Text('There is no favorite books. 😢'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 16, bottom: 30),
                  itemCount: state.favoriteTextbooks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: TextbookCard(
                        textbook: state.favoriteTextbooks[index],
                        onTap: () => Navigator.of(context).push(
                          createRoute(
                              page: TextbookDetailsScreen(
                                textbook: state.favoriteTextbooks[index],
                                showFavoriteButton: false,
                              ),
                              animationType: RouteAnimationType.slideFromRight),
                        ),
                        onRemove: () => viewModel
                            .removeFavorite(state.favoriteTextbooks[index]),
                      ),
                    );
                  },
                ),
    );
  }
}
