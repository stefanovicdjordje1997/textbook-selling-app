import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('sr')) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'sr';
    state = Locale(languageCode);
  }

  Future<void> toggleLanguage() async {
    state =
        state.languageCode == 'en' ? const Locale('sr') : const Locale('en');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', state.languageCode);
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});
