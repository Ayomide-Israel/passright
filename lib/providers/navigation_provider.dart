// navigation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/models/question_model.dart';

enum AppScreen {
  splash,
  onboarding,
  createAccount,
  login,
  dashboard,
  filter,
  questionDetail,
  practiceSession,
  chat,
}

final navigationProvider = StateProvider<AppScreen>((ref) => AppScreen.splash);

final dashboardIndexProvider = StateProvider<int>((ref) => 0);

final chatContextProvider = StateProvider<ChatContext?>((ref) => null);

class ChatContext {
  final Question question;
  final String subject;
  final String topic;

  ChatContext({
    required this.question,
    required this.subject,
    required this.topic,
  });
}

// Add a new provider to track navigation source
final chatNavigationSourceProvider = StateProvider<ChatSource>(
  (ref) => ChatSource.explanation,
);

enum ChatSource { dashboard, explanation }
