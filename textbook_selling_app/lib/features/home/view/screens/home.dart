import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constant/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/navigation/create_route.dart';
import 'package:textbook_selling_app/core/utils/loader_functions.dart';
import 'package:textbook_selling_app/features/add_textbook/view/screens/add_textbook.dart';
import 'package:textbook_selling_app/features/home/viewmodel/home_viewmodel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  final List<Widget> _tabs = const [
    TabContent(title: 'All ads will be shown here.'),
    TabContent(title: 'Favorite ads will be shown here.'),
    SizedBox.shrink(),
    TabContent(title: 'Your ads will be shown here.'),
    TabContent(title: 'Your profile will be shown here.'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    hideLoader(context);
    final viewModel = ref.watch(homeViewModelProvider.notifier);
    final currentIndex = ref.watch(homeViewModelProvider).index;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.getString(LocalKeys.home)),
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
              label: AppLocalizations.getString(LocalKeys.allAds)),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: AppLocalizations.getString(LocalKeys.favorites),
          ),
          // Empty space for floating button
          const BottomNavigationBarItem(
            icon: SizedBox.shrink(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: AppLocalizations.getString(LocalKeys.yourAds),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.getString(LocalKeys.profile),
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
