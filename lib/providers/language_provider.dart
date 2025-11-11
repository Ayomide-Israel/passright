// providers/language_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Define an enum for the available languages
enum AppLanguage { english, igbo, yoruba, hausa }

// 2. Create a provider to hold the currently selected language
//    We set English as the default.
final languageProvider = StateProvider<AppLanguage>(
  (ref) => AppLanguage.english,
);

// 3. (Optional) A helper to get the display name of the language
extension LanguageName on AppLanguage {
  String get name {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.igbo:
        return 'Igbo';
      case AppLanguage.yoruba:
        return 'Yorùbá';
      case AppLanguage.hausa:
        return 'Hausa';
    }
  }
}
