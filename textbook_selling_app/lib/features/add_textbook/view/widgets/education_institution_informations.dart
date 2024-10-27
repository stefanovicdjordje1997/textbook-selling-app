import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/widgets/card.dart';
import 'package:textbook_selling_app/core/widgets/dropdown_menu.dart';
import 'package:textbook_selling_app/core/widgets/text_form_field.dart';
import 'package:textbook_selling_app/features/add_textbook/viewmodel/add_textbook_viewmodel.dart';

class EducationInstitutionInformations extends ConsumerWidget {
  const EducationInstitutionInformations({
    super.key,
    required this.viewModel,
  });

  final AddTextbookViewModel viewModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final universities = ref.watch(addTextbookViewModelProvider).universities;
    final institutions = ref.watch(addTextbookViewModelProvider).institutions;
    final degreeLevels = ref.watch(addTextbookViewModelProvider).degreeLevels;
    final majors = ref.watch(addTextbookViewModelProvider).majors;

    return CustomCard(
      title: 'Education Institution Informations:',
      children: [
        CustomDropdownMenu<String>(
          labelText: 'Institution Type',
          searchLabel: viewModel.setSearchLabel(
              viewModel.institutionTypes, 'Search institution type'),
          items: viewModel.institutionTypes,
          defaultItem: 'Select institution type',
          itemDisplayValue: (item) => item,
          onSelectedItem: (item) {
            viewModel.onSavedInstitutionType(item);
            viewModel.getUniversities(context);
          },
          validator: viewModel.validateInstitutionType,
        ),
        CustomDropdownMenu<String>(
          labelText: 'University',
          searchLabel:
              viewModel.setSearchLabel(universities, 'Search universities'),
          enabled: universities != null && universities.isNotEmpty,
          items: universities ?? [],
          shouldResetSeletion: true,
          itemDisplayValue: (item) => item,
          onSelectedItem: (item) {
            viewModel.onSavedSelectedUniversity(item);
            viewModel.getInstitutions();
          },
          validator: (value) {
            return viewModel.validateDropdownField(
                value: value, options: universities, fieldName: 'University');
          },
        ),
        CustomDropdownMenu<String>(
          labelText: 'Edu. Institution',
          searchLabel:
              viewModel.setSearchLabel(institutions, 'Search institution'),
          enabled: institutions != null && institutions.isNotEmpty,
          items: institutions ?? [],
          shouldResetSeletion: true,
          itemDisplayValue: (item) => item,
          itemSearchValue: (item) => item,
          onSelectedItem: (item) {
            viewModel.onSavedSelectedInstitution(item);
            viewModel.getDegreeLevels();
          },
          validator: (value) {
            return viewModel.validateDropdownField(
                value: value,
                options: institutions,
                fieldName: 'Edu. Institution');
          },
        ),
        CustomDropdownMenu<String>(
          labelText: 'Degree Level',
          searchLabel:
              viewModel.setSearchLabel(degreeLevels, 'Search degree level'),
          enabled: degreeLevels != null && degreeLevels.isNotEmpty,
          items: degreeLevels ?? [],
          shouldResetSeletion: true,
          itemDisplayValue: (item) => item,
          onSelectedItem: (item) {
            viewModel.onSavedSelectedDegreeLevel(item);
            viewModel.getMajors();
          },
          validator: (value) {
            return viewModel.validateDropdownField(
                value: value, options: degreeLevels, fieldName: 'Degree level');
          },
        ),
        CustomDropdownMenu<String>(
          labelText: 'Major',
          searchLabel: viewModel.setSearchLabel(majors, 'Search institution'),
          enabled: majors != null && majors.isNotEmpty,
          items: majors ?? [],
          shouldResetSeletion: true,
          itemDisplayValue: (item) => item,
          onSelectedItem: (item) {
            viewModel.onSavedSelectedMajor(item);
          },
          validator: (value) {
            return viewModel.validateDropdownField(
                value: value, options: majors, fieldName: 'Major');
          },
        ),
        CustomTextFormField(
          labelText: 'Year of Study',
          hintText: 'Year of Study of a textbook',
          keyboardType: TextInputType.number,
          validator: viewModel.validateYearOfStudy,
          onSaved: viewModel.onSavedYearOfStudy,
        ),
      ],
    );
  }
}
