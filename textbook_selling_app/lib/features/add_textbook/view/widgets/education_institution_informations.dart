import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constant/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
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
      title: AppLocalizations.getString(
          LocalKeys.educationInstitutionInformationsTitle),
      children: [
        CustomDropdownMenu<String>(
          labelText: AppLocalizations.getString(LocalKeys.institutionTypeLabel),
          searchLabel: viewModel.setSearchLabel(viewModel.institutionTypes,
              AppLocalizations.getString(LocalKeys.institutionTypeSearchLabel)),
          items: viewModel.institutionTypes,
          defaultItem:
              AppLocalizations.getString(LocalKeys.institutionTypeDefaultItem),
          itemDisplayValue: (item) => item,
          onSelectedItem: (item) {
            viewModel.onSavedInstitutionType(item);
            viewModel.getUniversities(context);
          },
          validator: viewModel.validateInstitutionType,
        ),
        CustomDropdownMenu<String>(
          labelText: AppLocalizations.getString(LocalKeys.universityLabel),
          searchLabel: viewModel.setSearchLabel(universities,
              AppLocalizations.getString(LocalKeys.universitySearchLabel)),
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
                value: value,
                options: universities,
                fieldName:
                    AppLocalizations.getString(LocalKeys.universityLabel));
          },
        ),
        CustomDropdownMenu<String>(
          labelText: AppLocalizations.getString(LocalKeys.eduInstitutionLabel),
          searchLabel: viewModel.setSearchLabel(institutions,
              AppLocalizations.getString(LocalKeys.eduInstitutionSearchLabel)),
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
                fieldName:
                    AppLocalizations.getString(LocalKeys.eduInstitutionLabel));
          },
        ),
        CustomDropdownMenu<String>(
          labelText: AppLocalizations.getString(LocalKeys.degreeLevelLabel),
          searchLabel: viewModel.setSearchLabel(degreeLevels,
              AppLocalizations.getString(LocalKeys.degreeLevelSearchLabel)),
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
                value: value,
                options: degreeLevels,
                fieldName:
                    AppLocalizations.getString(LocalKeys.degreeLevelLabel));
          },
        ),
        CustomDropdownMenu<String>(
          labelText: AppLocalizations.getString(LocalKeys.majorLabel),
          searchLabel: viewModel.setSearchLabel(
              majors, AppLocalizations.getString(LocalKeys.majorSearchLabel)),
          enabled: majors != null && majors.isNotEmpty,
          items: majors ?? [],
          shouldResetSeletion: true,
          itemDisplayValue: (item) => item,
          onSelectedItem: (item) {
            viewModel.onSavedSelectedMajor(item);
          },
          validator: (value) {
            return viewModel.validateDropdownField(
                value: value,
                options: majors,
                fieldName: AppLocalizations.getString(LocalKeys.majorLabel));
          },
        ),
        CustomTextFormField(
          labelText: AppLocalizations.getString(LocalKeys.yearOfStudyLabel),
          hintText: AppLocalizations.getString(LocalKeys.yearOfStudyHintText),
          keyboardType: TextInputType.number,
          validator: viewModel.validateYearOfStudy,
          onSaved: viewModel.onSavedYearOfStudy,
        ),
      ],
    );
  }
}
