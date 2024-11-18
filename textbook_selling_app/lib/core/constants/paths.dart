class Paths {
  static const loaderAnimation = 'lib/core/assets/images/loader_animation.gif';
  static const loginImage = 'lib/core/assets/images/login_image.png';
  static const serbianLang = 'lib/core/localization/langs/sr.json';
  static const englishLang = 'lib/core/localization/langs/en.json';
  static const countryCodes = 'lib/core/assets/country_codes.json';
  static const localKeys = 'lib/core/constants/local_keys.dart';

  static String getLangPath({required String languageCode}) {
    return 'lib/core/localization/langs/$languageCode.json';
  }
}
