// navigation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppScreen { splash, onboarding, createAccount, login }

final navigationProvider = StateProvider<AppScreen>((ref) => AppScreen.splash);
