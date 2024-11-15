import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/widgets/card.dart';
import 'package:textbook_selling_app/core/widgets/text_form_field.dart';
import 'package:textbook_selling_app/core/widgets/switch.dart';
import 'package:textbook_selling_app/features/add_textbook/viewmodel/add_textbook_viewmodel.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/constant/local_keys.dart';

class TextbookInformations extends ConsumerWidget {
  const TextbookInformations({
    super.key,
    required this.viewModel,
  });

  final AddTextbookViewModel viewModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final used = ref.watch(addTextbookViewModelProvider).used;
    final damaged = ref.watch(addTextbookViewModelProvider).damaged;

    return CustomCard(
      title: AppLocalizations.getString(LocalKeys.textbookInformationsTitle),
      children: [
        CustomTextFormField(
          labelText: AppLocalizations.getString(LocalKeys.textbookNameLabel),
          hintText: AppLocalizations.getString(LocalKeys.textbookNameHint),
          validator: (value) {
            return viewModel.validateText(
                value: value,
                fieldName:
                    AppLocalizations.getString(LocalKeys.textbookNameLabel));
          },
          onSaved: viewModel.onSavedName,
        ),
        CustomTextFormField(
          labelText: AppLocalizations.getString(LocalKeys.subjectNameLabel),
          hintText: AppLocalizations.getString(LocalKeys.subjectNameHint),
          validator: (value) {
            return viewModel.validateText(
                value: value,
                fieldName:
                    AppLocalizations.getString(LocalKeys.subjectNameLabel));
          },
          onSaved: viewModel.onSavedSubject,
        ),
        CustomTextFormField(
          labelText: AppLocalizations.getString(LocalKeys.descriptionLabel),
          hintText: AppLocalizations.getString(LocalKeys.descriptionHint),
          maxLines: 5,
          validator: (value) => null,
          onSaved: viewModel.onSavedDescription,
        ),
        CustomTextFormField(
          labelText: AppLocalizations.getString(LocalKeys.publicationYearLabel),
          hintText: AppLocalizations.getString(LocalKeys.publicationYearHint),
          keyboardType: TextInputType.number,
          validator: viewModel.validatePublicationYear,
          onSaved: viewModel.onSavedYearOfPublication,
        ),
        CustomTextFormField(
          labelText: AppLocalizations.getString(LocalKeys.priceLabel),
          hintText: AppLocalizations.getString(LocalKeys.priceHint),
          keyboardType: TextInputType.number,
          validator: viewModel.validatePrice,
          onSaved: viewModel.onSavedPrice,
        ),
        CustomSwitch(
          labelText: AppLocalizations.getString(LocalKeys.usedLabel),
          value: used ?? false,
          onChanged: viewModel.onSavedUsed,
        ),
        if (used ?? false)
          CustomSwitch(
            labelText: AppLocalizations.getString(LocalKeys.damagedLabel),
            value: damaged ?? false,
            onChanged: viewModel.onSavedDamaged,
          ),
      ],
    );
  }
}
