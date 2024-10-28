import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constant/local_keys.dart';
import 'package:textbook_selling_app/core/constant/paths.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/localization/language_notifier.dart';
import 'package:textbook_selling_app/core/widgets/button.dart';
import 'package:textbook_selling_app/core/widgets/text_form_field.dart';
import 'package:textbook_selling_app/features/auth/view/widgets/register_redirection.dart';
import 'package:textbook_selling_app/features/auth/viewModel/login_viewmodel.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(loginViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.getString(LocalKeys.login)),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(languageProvider.notifier).toggleLanguage();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(ref.watch(languageProvider).languageCode),
                const SizedBox(width: 8),
                const Icon(Icons.language),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Paths.loginImage,
                height: 300,
                width: double.infinity,
              ),
              const SizedBox(height: 16),
              Form(
                key: viewModel.formKey,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        labelText:
                            AppLocalizations.getString(LocalKeys.emailLabel),
                        hintText:
                            AppLocalizations.getString(LocalKeys.emailHint),
                        validator: viewModel.validateEmail,
                        onSaved: viewModel.onSavedEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        labelText:
                            AppLocalizations.getString(LocalKeys.passwordLabel),
                        hintText:
                            AppLocalizations.getString(LocalKeys.passwordHint),
                        validator: viewModel.validatePassword,
                        onSaved: viewModel.onSavedPassword,
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        onPressed: () {
                          viewModel.saveForm(context);
                        },
                        text: AppLocalizations.getString(LocalKeys.login),
                      ),
                      const SizedBox(height: 20),
                      const CustomRichText(),
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
