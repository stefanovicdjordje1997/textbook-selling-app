import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/utils/create_route.dart';
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
    final viewModel = ref.watch(homeViewModelProvider.notifier);
    final currentIndex = ref.watch(homeViewModelProvider).index;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'All Ads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          // Empty space for floating button
          BottomNavigationBarItem(
            icon: SizedBox.shrink(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Your Ads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
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
