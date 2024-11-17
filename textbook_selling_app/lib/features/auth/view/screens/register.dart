import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constant/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/widgets/button.dart';
import 'package:textbook_selling_app/features/auth/view/widgets/date_picker.dart';
import 'package:textbook_selling_app/core/widgets/text_form_field.dart';
import 'package:textbook_selling_app/features/auth/view/widgets/dial_code_picker.dart';
import 'package:textbook_selling_app/features/auth/view/widgets/profile_image_picker.dart';
import 'package:textbook_selling_app/features/auth/viewModel/register_viewmodel.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(registerViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.getString(LocalKeys.register),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: viewModel.formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                ProfileImagePicker(
                  onPickImageFromCamera: viewModel.pickImageFromCamera,
                  onPickImageFromGallery: viewModel.pickImageFromGallery,
                  onRemoveImage: viewModel.removeImage,
                ),
                const SizedBox(height: 16),
                Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: AppLocalizations.getString(
                            LocalKeys.firstNameLabel),
                        hintText:
                            AppLocalizations.getString(LocalKeys.firstNameHint),
                        keyboardType: TextInputType.name,
                        capitalFirstLetter: true,
                        validator: (value) {
                          return viewModel.validateText(
                              value: value,
                              fieldName: AppLocalizations.getString(
                                  LocalKeys.firstNameLabel));
                        },
                        onSaved: viewModel.onSavedFirstName,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextFormField(
                        labelText:
                            AppLocalizations.getString(LocalKeys.lastNameLabel),
                        hintText:
                            AppLocalizations.getString(LocalKeys.lastNameHint),
                        keyboardType: TextInputType.name,
                        capitalFirstLetter: true,
                        validator: (value) {
                          return viewModel.validateText(
                              value: value,
                              fieldName: AppLocalizations.getString(
                                  LocalKeys.lastNameLabel));
                        },
                        onSaved: viewModel.onSavedLastName,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  labelText: AppLocalizations.getString(LocalKeys.emailLabel),
                  hintText: AppLocalizations.getString(LocalKeys.emailHint),
                  validator: viewModel.validateEmail,
                  onSaved: viewModel.onSavedEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  labelText:
                      AppLocalizations.getString(LocalKeys.passwordLabel),
                  hintText: AppLocalizations.getString(LocalKeys.passwordHint),
                  validator: viewModel.validatePassword,
                  onSaved: viewModel.onSavedPassword,
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  labelText:
                      AppLocalizations.getString(LocalKeys.repeatPasswordLabel),
                  hintText:
                      AppLocalizations.getString(LocalKeys.repeatPasswordHint),
                  validator: viewModel.validateRepeatedPassword,
                  onSaved: (value) {},
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                CustomDatePicker(
                  onDateSelected: viewModel.onSavedDateOfBirth,
                  validator: viewModel.validateDate,
                ),
                const SizedBox(height: 10),
                Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DialCodePicker(
                      onSaved: viewModel.onSavedDialCode,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextFormField(
                        labelText:
                            AppLocalizations.getString(LocalKeys.phoneLabel),
                        hintText:
                            AppLocalizations.getString(LocalKeys.phoneHint),
                        keyboardType: TextInputType.number,
                        validator: viewModel.validatePhoneNumber,
                        onSaved: viewModel.onSavePhoneNumber,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: () {
                    viewModel.saveForm(context);
                  },
                  text: AppLocalizations.getString(LocalKeys.register),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
