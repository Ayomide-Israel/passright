// providers/practice_session_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/models/question_model.dart';
import '../models/practice_session_state.dart';
import '../question_repo.dart';

class PracticeSessionNotifier extends StateNotifier<PracticeSessionState> {
  final QuestionsRepository _repository;

  PracticeSessionNotifier(this._repository)
    : super(const PracticeSessionState(questions: []));

  // Initialize session with questions
  Future<void> initializeSession({
    required String subject,
    required String examType,
    required String questionType,
    required String topic,
  }) async {
    final questions = await _repository.getQuestions(
      subject: subject,
      examType: examType,
      questionType: questionType,
      topic: topic,
    );

    state = state.copyWith(questions: questions);
  }

  // Select answer
  void selectAnswer(int answerIndex) {
    state = state.copyWith(selectedAnswer: answerIndex);
  }

  // Submit answer and show explanation
  void submitAnswer() {
    if (state.selectedAnswer == null || state.showExplanation) return;

    final currentQuestion = state.currentQuestion;
    final isCorrect = state.selectedAnswer == currentQuestion.correctAnswer;

    final updatedQuestions = List<Question>.from(state.questions);
    updatedQuestions[state.currentQuestionIndex] =
        updatedQuestions[state.currentQuestionIndex].copyWith(
          isAnswered: true,
          userAnswer: state.selectedAnswer,
          isCorrect: isCorrect,
        );

    // Recalculate scores from scratch to avoid double-counting
    final correctAnswers = updatedQuestions
        .where((q) => q.isCorrect == true)
        .length;
    final incorrectAnswers = updatedQuestions
        .where((q) => q.isAnswered && q.isCorrect == false)
        .length;

    state = state.copyWith(
      questions: updatedQuestions,
      showExplanation: true,
      correctAnswers: correctAnswers,
      incorrectAnswers: incorrectAnswers,
    );
  }

  // Navigate to next question
  void nextQuestion() {
    if (!state.hasNextQuestion) {
      state = state.copyWith(isCompleted: true);
      return;
    }

    state = PracticeSessionState(
      // Create new state instead of copyWith
      questions: state.questions,
      currentQuestionIndex: state.currentQuestionIndex + 1,
      selectedAnswer: null, // This will definitely be null
      showExplanation: false,
      correctAnswers: state.correctAnswers,
      incorrectAnswers: state.incorrectAnswers,
    );
  }

  // Navigate to previous question
  void previousQuestion() {
    if (!state.hasPreviousQuestion) return;

    state = PracticeSessionState(
      // Create new state instead of copyWith
      questions: state.questions,
      currentQuestionIndex: state.currentQuestionIndex - 1,
      selectedAnswer: null, // This will definitely be null
      showExplanation: false,
      correctAnswers: state.correctAnswers,
      incorrectAnswers: state.incorrectAnswers,
    );
  }

  // Reset session
  void resetSession() {
    state = const PracticeSessionState(questions: []);
  }
}

// Providers
final questionsRepositoryProvider = Provider<QuestionsRepository>((ref) {
  return QuestionsRepository();
});

final practiceSessionProvider =
    StateNotifierProvider<PracticeSessionNotifier, PracticeSessionState>((ref) {
      final repository = ref.read(questionsRepositoryProvider);
      return PracticeSessionNotifier(repository);
    });
