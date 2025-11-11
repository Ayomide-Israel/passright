// navigation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppScreen {
  splash,
  onboarding,
  createAccount,
  login,
  dashboard,
  filter,
  practiceSession,
  chat,
  questionDetail,
  coreSubjects,
  exploreResources,
  videoPlayer,
  vocationalTraining,
  skillDetail,
  language,
}

// Navigation provider to handle screen changes
final navigationProvider = StateProvider<AppScreen>((ref) => AppScreen.splash);

// Provider to track the current tab in dashboard
final dashboardIndexProvider = StateProvider<int>((ref) => 0);
