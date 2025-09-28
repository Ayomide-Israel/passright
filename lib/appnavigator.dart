// appnavigator.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/diva.dart';
import 'package:passright/screens/dashboard.dart';
import 'package:passright/screens/filter.dart';
import 'package:passright/screens/practice.dart';
import 'package:passright/screens/questions_detail.dart';
import 'package:passright/screens/splash_screen.dart';
import 'package:passright/screens/onboarding_screen.dart';
import 'package:passright/screens/create_account.dart';
import 'package:passright/screens/login_page.dart';
import 'package:passright/providers/navigation_provider.dart';
import 'package:passright/providers/filter_provider.dart'; // Add this import

class AppNavigator extends ConsumerWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentScreen = ref.watch(navigationProvider);
    final filterState = ref.watch(filterProvider); // Get filter state

    switch (currentScreen) {
      case AppScreen.splash:
        return const SplashScreen();
      case AppScreen.onboarding:
        return const OnboardingScreen();
      case AppScreen.createAccount:
        return const CreateAccountPage();
      case AppScreen.login:
        return const LoginPage();
      case AppScreen.dashboard:
        return const DashBoard();
      case AppScreen.filter:
        return const FiltersScreen();
      case AppScreen.questionDetail:
        return QuestionDetailScreen(
          questionNumber: 1,
          question: 'If 3x - 4 = 11, find the value of x.',
          options: ['3', '4', '5', '7'],
          correctAnswer: 2,
          explanation: 'Add 4 to both sides: 3x = 15. Then divide by 3: x = 5.',
        );
      case AppScreen.practiceSession:
        // Use actual filter values from provider with fallbacks
        return PracticeSessionScreen(
          subject: filterState.subject ?? 'Mathematics', // Fallback if null
          examType: filterState.examType ?? 'WAEC', // Fallback if null
          questionType:
              filterState.questionType ?? 'Multiple Choice', // Fallback
          topic: filterState.topic ?? 'All', // Fallback if null
        );
      case AppScreen.chat: // Add this case
        return const ChatScreen();
    }
  }
}
