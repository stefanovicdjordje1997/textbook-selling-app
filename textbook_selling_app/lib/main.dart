import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constants/paths.dart';
import 'package:textbook_selling_app/core/theme/theme.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/localization/language_notifier.dart';
import 'package:textbook_selling_app/features/auth/view/screens/login.dart';
import 'package:textbook_selling_app/features/home/view/screens/home.dart';
import 'package:textbook_selling_app/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageProvider);

    return MaterialApp(
      title: 'Textbook Selling App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      locale: currentLocale,
      supportedLocales: const [
        Locale('en'),
        Locale('sr'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: Image.asset(
                    Paths.loaderAnimation,
                    height: 100,
                    width: 100,
                  ),
                ),
              );
            }
            if (snapshot.hasData) {
              return const HomeScreen();
            }
            return const LoginScreen();
          }),
    );
  }
}
