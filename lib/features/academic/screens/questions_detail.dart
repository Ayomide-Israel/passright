// screens/question_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionDetailScreen extends ConsumerWidget {
  final int questionNumber;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;

  final bool isAnswered; // Add this
  final int? userAnswer; // Add this
  final bool? isCorrect;

  const QuestionDetailScreen({
    super.key,
    required this.questionNumber,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    this.isAnswered = false, // Default to false
    this.userAnswer,
    this.isCorrect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Question $questionNumber')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('${String.fromCharCode(65 + index)}. $option'),
              );
            }),
            const SizedBox(height: 24),
            const Text(
              'Explanation:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(explanation),
            const SizedBox(height: 24),
            const Text(
              'Dive Deeper with AI',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ask our AI tutor for a more detailed explanation of this concept.',
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to previous question
                  },
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to next question
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
