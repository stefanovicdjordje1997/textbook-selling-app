import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:textbook_selling_app/core/utils/create_route.dart';
import 'package:textbook_selling_app/features/auth/view/screens/register.dart';

class CustomRichText extends StatelessWidget {
  const CustomRichText({super.key});

  @override
  Widget build(BuildContext context) {
    void goToRegisterScreen(BuildContext context) {
      Navigator.of(context).push(createRoute(
          page: const RegisterScreen(),
          animationType: RouteAnimationType.fade));
    }

    return RichText(
      text: TextSpan(
        text: 'Don\'t have an account? ',
        style: Theme.of(context).textTheme.titleMedium,
        children: [
          TextSpan(
            text: 'Register',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                goToRegisterScreen(context);
              },
          ),
        ],
      ),
    );
  }
}
