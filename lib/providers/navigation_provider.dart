// navigation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppScreen {
  splash,
  onboarding,
  createAccount,
  login,
  dashboard,
  filter,
  questionDetail,
  practiceSession,
}

final navigationProvider = StateProvider<AppScreen>((ref) => AppScreen.splash);

final dashboardIndexProvider = StateProvider<int>((ref) => 0);
