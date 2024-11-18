import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:textbook_selling_app/core/constants/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/navigation/create_route.dart';
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
        text: AppLocalizations.getString(LocalKeys.dontHaveAnAccount),
        style: Theme.of(context).textTheme.titleMedium,
        children: [
          TextSpan(
            text: AppLocalizations.getString(LocalKeys.register),
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
