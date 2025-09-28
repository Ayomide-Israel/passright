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

  void _navigateToChat() {
    final sessionState = ref.read(practiceSessionProvider);
    final currentQuestion = sessionState.currentQuestion;

    // Set the chat context before navigating
    ref.read(chatContextProvider.notifier).state = ChatContext(
      question: currentQuestion,
      subject: widget.subject,
      topic: widget.topic,
    );

    // Set navigation source
    ref.read(chatNavigationSourceProvider.notifier).state =
        ChatSource.explanation;

    // Navigate to chat
    ref.read(navigationProvider.notifier).state = AppScreen.chat;
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
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 20,
          left: 20,
          right: 20,
          top: 50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    style: OutlinedButton.styleFrom(
                      shape: const CircleBorder(),
                      side: BorderSide(
                        color: Color.fromRGBO(0, 191, 166, 1),
                        width: 2.0,
                      ),
                      padding: EdgeInsets.all(12),
                    ),
                    onPressed: _handleBackButton,
                  ),
                ),
                // Centered title
                const Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 41,
                    width: 163,
                    child: Card(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      child: Center(
                        child: Text(
                          'Past Questions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(26, 61, 124, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 35),
            Text(
              widget.subject,
              style: TextStyle(
                color: Color.fromRGBO(26, 61, 124, 1),
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 27),
            Container(
              height: 30,
              width: 235,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Questions Type',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(26, 61, 124, 1),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.questionType,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(0, 191, 166, 1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Color.fromRGBO(241, 242, 245, 1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!, width: 1.0),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search Question',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.teal),
                ),
              ),
            ),

            const SizedBox(height: 40),
            // Progress indicator
            LinearProgressIndicator(
              value: sessionState.progress,
              backgroundColor: Colors.grey[300],
              color: const Color.fromRGBO(0, 191, 166, 1),
            ),
            const SizedBox(height: 14),

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
                        color: Color.fromRGBO(26, 61, 124, 1),
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
                    title: Text(option),
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: sessionState.selectedAnswer == null
                  ? null
                  : _submitAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0, 191, 166, 1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                fixedSize: const Size(188, 50),
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

    return Expanded(
      child: Column(
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
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  sessionState.hasNextQuestion ? 'Next Question' : 'Finish',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _navigateToChat, // Use the existing method instead of inline navigation
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(26, 61, 124, 1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                fixedSize: const Size(188, 50),
              ),
              child: const Text(
                'Dive Deeper With AI',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
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
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _handleCompletionBack,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 191, 166, 1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: const Text('Start New Practice Session'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
