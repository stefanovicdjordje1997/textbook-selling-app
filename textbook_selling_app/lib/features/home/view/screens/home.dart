import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constant/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/navigation/create_route.dart';
import 'package:textbook_selling_app/core/utils/loader_functions.dart';
import 'package:textbook_selling_app/features/add_textbook/view/screens/add_textbook.dart';
import 'package:textbook_selling_app/features/all_textbooks/view/screens/all_textbooks.dart';
import 'package:textbook_selling_app/features/home/viewmodel/home_viewmodel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  final List<Widget> _tabs = const [
    AllTextbooksScreen(),
    TabContent(title: 'Favorite ads will be shown here.'),
    SizedBox.shrink(),
    TabContent(title: 'Your ads will be shown here.'),
    TabContent(title: 'Your profile will be shown here.'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> tabNames = [
      AppLocalizations.getString(LocalKeys.allAds),
      AppLocalizations.getString(LocalKeys.favorites),
      '',
      AppLocalizations.getString(LocalKeys.yourAds),
      AppLocalizations.getString(LocalKeys.profile)
    ];
    hideLoader(context);
    final viewModel = ref.watch(homeViewModelProvider.notifier);
    final currentIndex = ref.watch(homeViewModelProvider).index;

    return Scaffold(
      appBar: AppBar(
        title: Text(tabNames[currentIndex ?? 0]),
        actions: [
          IconButton(
            onPressed: () => viewModel.logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _tabs[currentIndex ?? 0],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Go to add textbook screen
          Navigator.of(context).push(createRoute(
              page: const AddTextbookScreen(),
              animationType: RouteAnimationType.slideFromBottomAndFadeIn));
        },
        elevation: 2.0,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex ?? 0,
        onTap: viewModel.onTabSelected,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.book),
            label: tabNames[0],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: tabNames[1],
          ),
          // Empty space for floating button
          const BottomNavigationBarItem(
            icon: SizedBox.shrink(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: tabNames[3],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: tabNames[4],
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// Temporary method for showing tabs
class TabContent extends StatelessWidget {
  final String title;

  const TabContent({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title),
    );
  }
}
