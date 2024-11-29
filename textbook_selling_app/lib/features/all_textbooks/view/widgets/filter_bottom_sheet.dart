import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constants/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/widgets/dropdown_menu.dart';
import 'package:textbook_selling_app/core/widgets/text_form_field.dart';
import 'package:textbook_selling_app/features/all_textbooks/viewmodel/all_textbooks_viewmodel.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key, required this.onFilterApplied});

  final void Function(String? institutionType) onFilterApplied;

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  // @override
  // void deactivate() {
  //   ref.invalidate(filterBottomSheetViewmodelProvider);
  //   super.deactivate();
  // }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(allTextbooksProvider.notifier);
    final state = ref.watch(allTextbooksProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: viewModel.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.getString(LocalKeys.filterMenu),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 15),
                CustomDropdownMenu<String>(
                  labelText: AppLocalizations.getString(
                      LocalKeys.institutionTypeLabel),
                  items: viewModel.institutionTypes,
                  defaultItem: viewModel.setDefaultItem(
                      state.institutionType,
                      AppLocalizations.getString(
                          LocalKeys.institutionTypeDefaultItem)),
                  itemDisplayValue: (item) => item,
                  onSelectedItem: (value) {
                    viewModel.onSavedInstitutionType(value);
                    viewModel.getUniversities(context);
                  },
                ),
                const SizedBox(height: 10),
                CustomDropdownMenu<String>(
                  labelText:
                      AppLocalizations.getString(LocalKeys.universityLabel),
                  enabled: state.universities != null &&
                      state.universities!.isNotEmpty,
                  items: state.universities ?? [],
                  defaultItem: state.selectedUniversity,
                  shouldResetSeletion: true,
                  itemDisplayValue: (item) => item,
                  onSelectedItem: (item) {
                    viewModel.onSavedSelectedUniversity(item);
                    viewModel.getInstitutions();
                  },
                ),
                const SizedBox(height: 10),
                CustomDropdownMenu<String>(
                  labelText:
                      AppLocalizations.getString(LocalKeys.eduInstitutionLabel),
                  searchLabel: viewModel.setSearchLabel(
                      state.institutions,
                      AppLocalizations.getString(
                          LocalKeys.eduInstitutionSearchLabel)),
                  enabled: state.institutions != null &&
                      state.institutions!.isNotEmpty,
                  items: state.institutions ?? [],
                  defaultItem: state.selectedInstitution,
                  shouldResetSeletion: true,
                  itemDisplayValue: (item) => item,
                  itemSearchValue: (item) => item,
                  onSelectedItem: (item) {
                    viewModel.onSavedSelectedInstitution(item);
                    viewModel.getDegreeLevels();
                  },
                ),
                const SizedBox(height: 10),
                CustomDropdownMenu<String>(
                  labelText:
                      AppLocalizations.getString(LocalKeys.degreeLevelLabel),
                  enabled: state.degreeLevels != null &&
                      state.degreeLevels!.isNotEmpty,
                  items: state.degreeLevels ?? [],
                  defaultItem: state.selectedDegreeLevel,
                  shouldResetSeletion: true,
                  itemDisplayValue: (item) => item,
                  onSelectedItem: (item) {
                    viewModel.onSavedSelectedDegreeLevel(item);
                    viewModel.getMajors();
                  },
                ),
                const SizedBox(height: 10),
                CustomDropdownMenu<String>(
                  labelText: AppLocalizations.getString(LocalKeys.majorLabel),
                  enabled: state.majors != null && state.majors!.isNotEmpty,
                  items: state.majors ?? [],
                  defaultItem: state.selectedMajor,
                  shouldResetSeletion: true,
                  itemDisplayValue: (item) => item,
                  onSelectedItem: viewModel.onSavedSelectedMajor,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  labelText:
                      AppLocalizations.getString(LocalKeys.yearOfStudyLabel),
                  hintText:
                      AppLocalizations.getString(LocalKeys.yearOfStudyHintText),
                  defaultText: state.yearOfStudy != 0
                      ? state.yearOfStudy?.toString()
                      : null,
                  keyboardType: TextInputType.number,
                  validator: viewModel.validateYearOfStudy,
                  onSaved: (value) {
                    viewModel.onSavedYearOfStudy(value);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        viewModel.resetFilters(context);
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.getString(LocalKeys.reset)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final isValid =
                            await viewModel.filterTextbooks(context);
                        if (isValid && context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                          AppLocalizations.getString(LocalKeys.applyFilters)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
