import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/widgets/card.dart';
import 'package:textbook_selling_app/core/widgets/text_form_field.dart';
import 'package:textbook_selling_app/features/add_textbook/view/widgets/switch.dart';
import 'package:textbook_selling_app/features/add_textbook/viewmodel/add_textbook_viewmodel.dart';

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
      title: 'Textbook Informations:',
      children: [
        CustomTextFormField(
          labelText: 'Textbook name',
          hintText: 'Enter textbook name',
          validator: (value) {
            return viewModel.validateText(
                value: value, fieldName: 'Textbook name');
          },
          onSaved: viewModel.onSavedName,
        ),
        CustomTextFormField(
          labelText: 'Subject name',
          hintText: 'Enter subject name',
          validator: (value) {
            return viewModel.validateText(
                value: value, fieldName: 'Subject name');
          },
          onSaved: viewModel.onSavedSubject,
        ),
        CustomTextFormField(
          labelText: 'Description',
          hintText: 'Enter description',
          maxLines: 5,
          validator: (value) => null,
          onSaved: viewModel.onSavedDescription,
        ),
        CustomTextFormField(
          labelText: 'Publication year',
          hintText: 'Enter publication year',
          keyboardType: TextInputType.number,
          validator: viewModel.validatePublicationYear,
          onSaved: viewModel.onSavedYearOfPublication,
        ),
        CustomTextFormField(
          labelText: 'Price',
          hintText: 'Enter price in RSD',
          keyboardType: TextInputType.number,
          validator: viewModel.validatePrice,
          onSaved: viewModel.onSavedPrice,
        ),
        CustomSwitch(
          labelText: 'Used',
          value: used ?? false,
          onChanged: viewModel.onSavedUsed,
        ),
        if (used ?? false)
          CustomSwitch(
            labelText: 'Damaged',
            value: damaged ?? false,
            onChanged: viewModel.onSavedDamaged,
          ),
      ],
    );
  }
}
