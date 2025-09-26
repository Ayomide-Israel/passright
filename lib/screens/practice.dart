// screens/practice_session_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/models/practice_session_state.dart';
import 'package:passright/models/question_model.dart';
import 'package:passright/providers/navigation_provider.dart';
import 'package:passright/providers/practice_provider.dart';

class PracticeSessionScreen extends ConsumerStatefulWidget {
  final String subject;
  final String examType;
  final String questionType;
  final String topic;

  const PracticeSessionScreen({
    super.key,
    required this.subject,
    required this.examType,
    required this.questionType,
    required this.topic,
  });

  @override
  ConsumerState<PracticeSessionScreen> createState() =>
      _PracticeSessionScreenState();
}

class _PracticeSessionScreenState extends ConsumerState<PracticeSessionScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize session when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetAndInitializeSession();
    });
  }

  void _resetAndInitializeSession() {
    // Force reset the session to clear any previous state
    ref.read(practiceSessionProvider.notifier).resetSession();

    // Then initialize with new parameters
    _initializeSession();
  }

  void _initializeSession() {
    ref
        .read(practiceSessionProvider.notifier)
        .initializeSession(
          subject: widget.subject,
          examType: widget.examType,
          questionType: widget.questionType,
          topic: widget.topic,
        );
  }

  void _submitAnswer() {
    ref.read(practiceSessionProvider.notifier).submitAnswer();
  }

  void _nextQuestion() {
    ref.read(practiceSessionProvider.notifier).nextQuestion();
  }

  void _previousQuestion() {
    ref.read(practiceSessionProvider.notifier).previousQuestion();
  }

  void _selectAnswer(int answerIndex) {
    ref.read(practiceSessionProvider.notifier).selectAnswer(answerIndex);
  }

  void _handleBackButton() {
    // Reset session and navigate back to filter screen
    ref.read(practiceSessionProvider.notifier).resetSession();
    ref.read(navigationProvider.notifier).state = AppScreen.filter;
  }

  void _handleCompletionBack() {
    // Reset session and go back to filter screen
    ref.read(practiceSessionProvider.notifier).resetSession();
    ref.read(navigationProvider.notifier).state = AppScreen.filter;
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(practiceSessionProvider);

    // Show loading if questions are being fetched
    if (sessionState.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.subject} Practice'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBackButton,
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Show completion screen if session is completed
    if (sessionState.isCompleted) {
      return _buildCompletionScreen(sessionState);
    }

    final currentQuestion = sessionState.currentQuestion;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subject} Practice'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBackButton,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: sessionState.progress,
              backgroundColor: Colors.grey[300],
              color: const Color.fromRGBO(0, 191, 166, 1),
            ),
            const SizedBox(height: 16),

            // Question header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${sessionState.currentQuestionIndex + 1} of ${sessionState.totalQuestions}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentQuestion.question,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Options or Explanation based on state
            if (!sessionState.showExplanation)
              _buildOptionsSection(sessionState, currentQuestion)
            else
              _buildExplanationSection(sessionState, currentQuestion),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsSection(
    PracticeSessionState sessionState,
    Question currentQuestion,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select your answer:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: currentQuestion.options.length,
              itemBuilder: (context, index) {
                final option = currentQuestion.options[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(option), // REMOVED alphabetical prefix
                    leading: Radio<int>(
                      value: index,
                      groupValue: sessionState.selectedAnswer,
                      onChanged: (int? value) {
                        _selectAnswer(value!);
                      },
                    ),
                    onTap: () {
                      _selectAnswer(index);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: sessionState.selectedAnswer == null
                  ? null
                  : _submitAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0, 191, 166, 1),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'SUBMIT ANSWER',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationSection(
    PracticeSessionState sessionState,
    Question currentQuestion,
  ) {
    final isCorrect =
        sessionState.selectedAnswer == currentQuestion.correctAnswer;

    return Column(
      children: [
        Card(
          color: isCorrect ? Colors.green[50] : Colors.red[50],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isCorrect ? 'Correct!' : 'Incorrect',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Explanation:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(currentQuestion.explanation),
                const SizedBox(height: 16),
                const Text(
                  'Dive Deeper with AI',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ask our AI tutor for a more detailed explanation of this concept.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: sessionState.hasPreviousQuestion
                  ? _previousQuestion
                  : null,
              child: const Text('Previous'),
            ),
            ElevatedButton(
              onPressed: _nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0, 191, 166, 1),
              ),
              child: Text(
                sessionState.hasNextQuestion ? 'Next Question' : 'Finish',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompletionScreen(PracticeSessionState sessionState) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Completed'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleCompletionBack,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.celebration, size: 100, color: Colors.green),
            const SizedBox(height: 24),
            Text(
              'Practice Completed!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Score: ${sessionState.correctAnswers}/${sessionState.totalQuestions}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _handleCompletionBack, // Use consistent navigation
              child: const Text('Start New Practice Session'), // Better text
            ),
          ],
        ),
      ),
    );
  }
}
