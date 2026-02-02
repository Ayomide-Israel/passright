// providers/language_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Add 'pidgin' to the enum
enum AppLanguage {
  english,
  igbo,
  yoruba,
  hausa,
  pidgin, // <-- Added this
}

// 2. Create the provider (unchanged)
final languageProvider = StateProvider<AppLanguage>(
  (ref) => AppLanguage.english,
);

// 3. Update the name extension
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
      case AppLanguage.pidgin:
        return 'Nigerian Pidgin';
    }
  }
}
