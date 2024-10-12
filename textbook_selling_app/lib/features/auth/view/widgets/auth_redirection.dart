import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:textbook_selling_app/core/utils/create_route.dart';
import 'package:textbook_selling_app/features/auth/view/screens/login.dart';
import 'package:textbook_selling_app/features/auth/view/screens/register.dart';

enum AuthType {
  login,
  register,
}

class CustomRichText extends StatelessWidget {
  const CustomRichText({super.key, required this.authType});

  final AuthType authType;

  @override
  Widget build(BuildContext context) {
    final isLogin = authType == AuthType.login;

    void goToLoginScreen(BuildContext context) {
      Navigator.of(context).pushReplacement(createRoute(
          page: const LoginScreen(), animationType: RouteAnimationType.fade));
    }

    void goToRegisterScreen(BuildContext context) {
      Navigator.of(context).pushReplacement(createRoute(
          page: const RegisterScreen(),
          animationType: RouteAnimationType.fade));
    }

    return RichText(
      text: TextSpan(
        text:
            isLogin ? 'Don\'t have an account? ' : 'Already have an account? ',
        style: Theme.of(context).textTheme.titleMedium,
        children: [
          TextSpan(
            text: isLogin ? 'Register' : 'Login',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                if (isLogin) {
                  goToRegisterScreen(context);
                } else {
                  goToLoginScreen(context);
                }
              },
          ),
        ],
      ),
    );
  }
}
