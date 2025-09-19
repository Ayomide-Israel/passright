// main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/screens/splash_screen.dart';
import 'package:passright/screens/onboarding_screen.dart';
import 'package:passright/screens/create_account.dart';
import 'package:passright/screens/login_page.dart';
import 'package:passright/providers/navigation_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const AppNavigator(),
    );
  }
}

class AppNavigator extends ConsumerWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentScreen = ref.watch(navigationProvider);

    switch (currentScreen) {
      case AppScreen.splash:
        return const SplashScreen();
      case AppScreen.onboarding:
        return const OnboardingScreen();
      case AppScreen.createAccount:
        return const CreateAccountPage();
      case AppScreen.login:
        return const LoginPage();
    }
  }
}
