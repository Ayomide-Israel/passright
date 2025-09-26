// models/practice_session_model.dart
import 'package:passright/models/question_model.dart';

class PracticeSessionState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final int? selectedAnswer;
  final bool showExplanation;
  final bool isCompleted;
  final int correctAnswers;
  final int incorrectAnswers;

  const PracticeSessionState({
    required this.questions,
    this.currentQuestionIndex = 0,
    this.selectedAnswer,
    this.showExplanation = false,
    this.isCompleted = false,
    this.correctAnswers = 0,
    this.incorrectAnswers = 0,
  });

  PracticeSessionState copyWith({
    List<Question>? questions,
    int? currentQuestionIndex,
    int? selectedAnswer,
    bool? showExplanation,
    bool? isCompleted,
    int? correctAnswers,
    int? incorrectAnswers,
  }) {
    return PracticeSessionState(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      showExplanation: showExplanation ?? this.showExplanation,
      isCompleted: isCompleted ?? this.isCompleted,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
    );
  }

  Question get currentQuestion => questions[currentQuestionIndex];
  int get totalQuestions => questions.length;
  double get progress =>
      totalQuestions > 0 ? (currentQuestionIndex + 1) / totalQuestions : 0;
  bool get hasNextQuestion => currentQuestionIndex < totalQuestions - 1;
  bool get hasPreviousQuestion => currentQuestionIndex > 0;
}
