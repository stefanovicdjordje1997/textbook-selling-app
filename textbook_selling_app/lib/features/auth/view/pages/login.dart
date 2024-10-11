import 'package:flutter/material.dart';
import 'package:textbook_selling_app/core/widgets/button.dart';
import 'package:textbook_selling_app/core/widgets/text_form_field.dart';
import 'package:textbook_selling_app/features/auth/view/widgets/auth_redirection.dart';
import 'package:textbook_selling_app/features/auth/viewmodel/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final viewModel = LoginViewmodel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/core/assets/images/login_image.png',
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
                      const SizedBox(height: 20),
                      CustomButton(
                        onPressed: viewModel.saveForm,
                        text: 'Login',
                      ),
                      const SizedBox(height: 20),
                      const CustomRichText(authType: AuthType.login)
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
