import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:textbook_selling_app/features/auth/view/pages/login.dart';
import 'package:textbook_selling_app/features/auth/view/pages/register.dart';

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

    PageRouteBuilder createRoute(Widget page) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animation);

          return FadeTransition(
            opacity: fadeAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      );
    }

    void goToLoginScreen(BuildContext context) {
      Navigator.of(context).pushReplacement(createRoute(const LoginScreen()));
    }

    void goToRegisterScreen(BuildContext context) {
      Navigator.of(context)
          .pushReplacement(createRoute(const RegisterScreen()));
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
