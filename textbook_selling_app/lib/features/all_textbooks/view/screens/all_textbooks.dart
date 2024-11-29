import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constants/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/navigation/create_route.dart';
import 'package:textbook_selling_app/core/widgets/loader.dart';
import 'package:textbook_selling_app/core/widgets/textbook_card.dart';
import 'package:textbook_selling_app/features/all_textbooks/view/widgets/filter_bottom_sheet.dart';
import 'package:textbook_selling_app/features/all_textbooks/viewmodel/all_textbooks_viewmodel.dart';
import 'package:textbook_selling_app/features/chat/view/screens/chats.dart';
import 'package:textbook_selling_app/features/textbook_details/view/screens/textbook_details.dart';

class AllTextbooksScreen extends ConsumerStatefulWidget {
  const AllTextbooksScreen({super.key});

  @override
  ConsumerState<AllTextbooksScreen> createState() => _AllTextbooksScreenState();
}

class _AllTextbooksScreenState extends ConsumerState<AllTextbooksScreen> {
  final int limit = 2;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final viewModel = ref.read(allTextbooksProvider.notifier);
      if (ref.read(allTextbooksProvider).textbooks == null && context.mounted) {
        viewModel.fetchTextbooks(context: context);
      }
    });
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return FilterBottomSheet(
          onFilterApplied: (filter) {
            final viewModel = ref.read(allTextbooksProvider.notifier);
            viewModel.refreshTextbooks(context);
            viewModel.fetchTextbooks(context: context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(allTextbooksProvider.notifier);
    final textbooks = ref.watch(allTextbooksProvider).textbooks;
    final isLoading = ref.watch(allTextbooksProvider).isLoading;
    final totalItems = ref.watch(allTextbooksProvider).totalItems;
    final currentPage = ref.watch(allTextbooksProvider).currentPage;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.getString(LocalKeys.allAds),
        ),
        actions: [
          IconButton(
            onPressed: () => _openFilterBottomSheet(),
            icon: const Icon(Icons.tune),
          ),
          IconButton(
            onPressed: () => viewModel.refreshTextbooks(context),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (isLoading && (textbooks == null || textbooks.isEmpty)) {
            // Prikaz loader-a dok se inicijalno učitavaju podaci
            return const Loader();
          }

          if (textbooks != null && textbooks.isEmpty && !isLoading) {
            // Prikaz kada nema dostupnih podataka nakon učitavanja
            return Center(
              child: Text(AppLocalizations.getString(LocalKeys.noTextbooks)),
            );
          }

          // Prikaz liste podataka ili paginacija
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (!isLoading &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  textbooks!.length < totalItems) {
                viewModel.fetchTextbooks(
                  context: context,
                  page: currentPage + 1,
                  limit: limit,
                );
              }
              return true;
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 30),
              itemCount: textbooks != null
                  ? textbooks.length +
                      (isLoading && textbooks.length < totalItems ? 1 : 0)
                  : 0,
              itemBuilder: (context, index) {
                if (index == textbooks?.length &&
                    isLoading &&
                    textbooks!.length < totalItems) {
                  return const Center(
                    child: Loader(
                      width: 40,
                      height: 40,
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: TextbookCard(
                    textbook: textbooks![index],
                    onTap: () {
                      Navigator.of(context).push(
                        createRoute(
                            page: TextbookDetailsScreen(
                              textbook: textbooks[index],
                              context: TextbookDetailsContext.favorites,
                            ),
                            animationType: RouteAnimationType.slideFromRight),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: StreamBuilder<int>(
        stream: viewModel.streamTotalUnreadMessages(),
        builder: (context, snapshot) {
          int unreadMessages = snapshot.data ?? 0;

          return Stack(
            alignment: Alignment.center,
            children: [
              FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  Navigator.of(context).push(
                    createRoute(
                        page: const ChatsScreen(),
                        animationType: RouteAnimationType.slideFromRight),
                  );
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.chat),
              ),
              if (unreadMessages > 0)
                Positioned(
                  right: 7,
                  bottom: 25,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unreadMessages',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
