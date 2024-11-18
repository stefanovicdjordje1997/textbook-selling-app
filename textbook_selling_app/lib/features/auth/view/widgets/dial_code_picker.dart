import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constants/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/widgets/dropdown_menu.dart';
import 'package:textbook_selling_app/features/auth/viewModel/register_viewmodel.dart';

class DialCodePicker extends ConsumerWidget {
  const DialCodePicker({super.key, required this.onSaved});

  final void Function(String? value) onSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(registerViewModelProvider.notifier);
    final countries = ref.watch(registerViewModelProvider).countries;
    final defaultItem = ref.watch(registerViewModelProvider).defaultItem;
    var currentItem = {};

    if (countries == null || countries.isEmpty) {
      viewModel.loadCountries();
      return const CircularProgressIndicator();
    }

    return Expanded(
      child: CustomDropdownMenu<dynamic>(
        labelText: AppLocalizations.getString(LocalKeys.dialCodeLabel),
        items: countries,
        defaultItem: defaultItem,
        searchLabel: AppLocalizations.getString(LocalKeys.dialCodeSearchLabel),
        itemDisplayValue: (item) =>
            '${item['emoji']} ${item['name']} (${item['dial_code']})',
        selectedItemDisplayValue: (selectedItem) {
          currentItem = selectedItem;
          return '${selectedItem['emoji']} (${selectedItem['dial_code']})';
        },
        onSaved: (value) {
          onSaved(currentItem['dial_code']);
        },
        itemSearchValue: (item) => item['name'] ?? '',
      ),
    );
  }
}
