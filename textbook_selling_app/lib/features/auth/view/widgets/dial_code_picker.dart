import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/widgets/dropdown_menu.dart';
import 'package:textbook_selling_app/features/auth/viewmodel/register_viewmodel.dart';

class DialCodePicker extends ConsumerWidget {
  const DialCodePicker({super.key, required this.onSaved});

  final void Function(String? value) onSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(registerViewModelProvider.notifier);
    final countries = ref.watch(registerViewModelProvider).countries;
    final defaultItem = ref.watch(registerViewModelProvider).defaultItem;
    var _currentItem = {};

    if (countries == null || countries.isEmpty) {
      // Ako zemlje još nisu učitane
      viewModel.loadCountries();
      return const CircularProgressIndicator();
    }

    return Expanded(
      child: CustomDropdownMenu<dynamic>(
        title: 'Dial Code',
        items: countries,
        defaultItem: defaultItem,
        searchLabel: 'Search Countries',
        itemDisplayValue: (item) =>
            '${item['emoji']} ${item['name']} (${item['dial_code']})',
        selectedItemDisplayValue: (selectedItem) {
          _currentItem = selectedItem;
          return '${selectedItem['emoji']} (${selectedItem['dial_code']})';
        },
        onSaved: (value) {
          onSaved(_currentItem['dial_code']);
        },
        itemSearchValue: (item) => item['name'] ?? '',
      ),
    );
  }
}
