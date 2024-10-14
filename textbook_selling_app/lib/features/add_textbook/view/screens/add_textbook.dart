import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/widgets/button.dart';
import 'package:textbook_selling_app/core/widgets/dropdown_menu.dart';
import 'package:textbook_selling_app/core/widgets/text_form_field.dart';
import 'package:textbook_selling_app/features/add_textbook/viewmodel/add_textbook_viewmodel.dart';

class AddTextbookScreen extends ConsumerStatefulWidget {
  const AddTextbookScreen({super.key});

  @override
  ConsumerState<AddTextbookScreen> createState() => _AddTextbookScreenState();
}

class _AddTextbookScreenState extends ConsumerState<AddTextbookScreen> {
  @override
  void deactivate() {
    // Reset state of the provider before dispose
    ref.invalidate(addTextbookViewModelProvider);

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(addTextbookViewModelProvider.notifier);
    final universities = ref.watch(addTextbookViewModelProvider).universities;
    final institutions = ref.watch(addTextbookViewModelProvider).institutions;
    final degreeLevels = ref.watch(addTextbookViewModelProvider).degreeLevels;
    final majors = ref.watch(addTextbookViewModelProvider).majors;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Textbook'),
        ),
        body: SingleChildScrollView(
          child: Form(
              key: viewModel.formKey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    CustomDropdownMenu<String>(
                      title: 'Institution Type',
                      searchLabel: viewModel.setSearchLabel(
                          viewModel.institutionTypes,
                          'Search institution type'),
                      items: viewModel.institutionTypes,
                      defaultItem: 'Select institution type',
                      itemDisplayValue: (item) => item,
                      onSelectedItem: (item) {
                        viewModel.onSavedInstitutionType(item);
                        viewModel.getUniversities(context);
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomDropdownMenu<String>(
                      title: 'University',
                      searchLabel: viewModel.setSearchLabel(
                          universities, 'Search universities'),
                      enabled: universities != null && universities.isNotEmpty,
                      items: universities ?? [],
                      defaultItem: 'Select University',
                      shouldResetSeletion: true,
                      itemDisplayValue: (item) => item,
                      onSelectedItem: (item) {
                        viewModel.onSavedSelectedUniversity(item);
                        viewModel.getInstitutions();
                      },
                      validator: viewModel.validateUniversity,
                    ),
                    const SizedBox(height: 10),
                    CustomDropdownMenu<String>(
                      title: 'Edu. Institution',
                      searchLabel: viewModel.setSearchLabel(
                          institutions, 'Search institution'),
                      enabled: institutions != null && institutions.isNotEmpty,
                      items: institutions ?? [],
                      defaultItem: 'Select Institution',
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
                      title: 'Degree Level',
                      searchLabel: viewModel.setSearchLabel(
                          degreeLevels, 'Search degree level'),
                      enabled: degreeLevels != null && degreeLevels.isNotEmpty,
                      items: degreeLevels ?? [],
                      defaultItem: 'Select degree level',
                      shouldResetSeletion: true,
                      itemDisplayValue: (item) => item,
                      onSelectedItem: (item) {
                        viewModel.onSavedSelectedDegreeLevel(item);
                        viewModel.getMajors();
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomDropdownMenu<String>(
                      title: 'Majors',
                      searchLabel: viewModel.setSearchLabel(
                          institutions, 'Search institution'),
                      enabled: majors != null && majors.isNotEmpty,
                      items: majors ?? [],
                      defaultItem: 'Select major',
                      shouldResetSeletion: true,
                      itemDisplayValue: (item) => item,
                      onSelectedItem: (item) {
                        viewModel.onSavedSelectedMajor(item);
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      labelText: 'Year of Study',
                      hintText: 'Year of Study of a textbook',
                      keyboardType: TextInputType.number,
                      validator: viewModel.validateYearOfStudy,
                      onSaved: viewModel.onSavedYearOfStudy,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                        onPressed: () {
                          viewModel.saveForm(context);
                        },
                        text: 'Add Textbook')
                  ],
                ),
              )),
        ));
  }
}
