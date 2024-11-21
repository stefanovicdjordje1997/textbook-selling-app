import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constants/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/navigation/create_route.dart';
import 'package:textbook_selling_app/core/utils/loader_functions.dart';
import 'package:textbook_selling_app/features/add_textbook/view/screens/add_textbook.dart';
import 'package:textbook_selling_app/features/all_textbooks/view/screens/all_textbooks.dart';
import 'package:textbook_selling_app/features/favorite_textbooks/view/screens/favorite_textbooks.dart';
import 'package:textbook_selling_app/features/home/viewmodel/home_viewmodel.dart';
import 'package:textbook_selling_app/features/my_textbooks.dart/view/my_textbooks.dart';
import 'package:textbook_selling_app/features/profile/view/screens/profile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  final List<Widget> _tabs = const [
    AllTextbooksScreen(),
    FavoriteTextbooksScreen(),
    SizedBox.shrink(),
    MyTextbooksScreen(),
    ProfileScreen(),
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
      body: _tabs[currentIndex ?? 0],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Go to add textbook screen
          Navigator.of(context).push(createRoute(
              page: const AddTextbookScreen(mode: TextbookMode.editing),
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
