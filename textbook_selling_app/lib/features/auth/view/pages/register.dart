import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/widgets/button.dart';
import 'package:textbook_selling_app/features/auth/view/widgets/auth_redirection.dart';
import 'package:textbook_selling_app/features/auth/view/widgets/date_picker.dart';
import 'package:textbook_selling_app/core/widgets/text_form_field.dart';
import 'package:textbook_selling_app/features/auth/view/widgets/dial_code_picker.dart';
import 'package:textbook_selling_app/features/auth/viewmodel/register_viewmodel.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(registerViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/core/assets/images/register_image.png',
                height: 300,
                width: double.infinity,
              ),
              const SizedBox(height: 16),
              Form(
                key: viewModel.formKey, // FormKey iz ViewModel-a
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Flex(
                        direction: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              labelText: 'Name',
                              hintText: 'John',
                              keyboardType: TextInputType.name,
                              capitalFirstLetter: true,
                              validator: viewModel.validateText,
                              onSaved: viewModel.onSavedName,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextFormField(
                              labelText: 'Surname',
                              hintText: 'Doe',
                              keyboardType: TextInputType.name,
                              capitalFirstLetter: true,
                              validator: viewModel.validateText,
                              onSaved: viewModel.onSavedSurname,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        labelText: 'Email',
                        hintText: 'email@example.com',
                        validator: viewModel.validateEmail,
                        onSaved: viewModel.onSavedEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        labelText: 'Password',
                        hintText: 'Minimum 6 characters',
                        validator: viewModel.validatePassword,
                        onSaved: viewModel.onSavedPassword,
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        labelText: 'Repeat password',
                        hintText: 'Repeat your password',
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
                              labelText: 'Phone number',
                              hintText: '612345678',
                              keyboardType: TextInputType.number,
                              validator: viewModel.validatePhoneNumber,
                              onSaved: viewModel.onSavePhoneNumber,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        onPressed: viewModel.saveForm,
                        text: 'Register',
                      ),
                      const SizedBox(height: 20),
                      const CustomRichText(
                        authType: AuthType.register,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
