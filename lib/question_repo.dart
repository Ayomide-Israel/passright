// repositories/questions_repository.dart
import '../models/question_model.dart';

class QuestionsRepository {
  // In a real app, this would fetch from an API or database
  Future<List<Question>> getQuestions({
    required String subject,
    required String examType,
    required String questionType,
    required String topic,
    int limit = 10,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data - replace with actual API call
    return _generateMockQuestions(
      subject: subject,
      examType: examType,
      questionType: questionType,
      topic: topic,
      limit: limit,
    );
  }

  List<Question> _generateMockQuestions({
    required String subject,
    required String examType,
    required String questionType,
    required String topic,
    int limit = 10,
  }) {
    final questions = <Question>[];

    if (subject == 'Mathematics') {
      questions.addAll(_getMathematicsQuestions());
    } else if (subject == 'English Language') {
      questions.addAll(_getEnglishQuestions());
    } else if (subject == 'Physics') {
      questions.addAll(_getPhysicsQuestions());
    }

    // Filter by topic if not "All"
    if (topic != 'All') {
      questions.removeWhere((q) => q.topic != topic);
    }

    return questions.take(limit).toList();
  }

  List<Question> _getMathematicsQuestions() {
    return [
      Question(
        id: 1,
        question: 'If 3x - 4 = 11, find the value of x.',
        options: ['3', '4', '5', '7'],
        correctAnswer: 2,
        explanation: 'Add 4 to both sides: 3x = 15. Then divide by 3: x = 5.',
        subject: 'Mathematics',
        topic: 'Algebra',
        examType: 'WAEC',
        questionType: 'Multiple Choice',
        year: 2023,
      ),
      Question(
        id: 2,
        question: 'Simplify: 2(x + 3) - 3(x - 1)',
        options: ['-x + 9', 'x + 9', '-x + 3', 'x + 3'],
        correctAnswer: 0,
        explanation: 'Expand: 2x + 6 - 3x + 3 = -x + 9',
        subject: 'Mathematics',
        topic: 'Algebra',
        examType: 'WAEC',
        questionType: 'Multiple Choice',
        year: 2023,
      ),
      Question(
        id: 3,
        question: 'What is the value of π (pi) to two decimal places?',
        options: ['3.14', '3.16', '3.18', '3.12'],
        correctAnswer: 0,
        explanation:
            'π is approximately 3.14159, which rounds to 3.14 to two decimal places.',
        subject: 'Mathematics',
        topic: 'Geometry',
        examType: 'WAEC',
        questionType: 'Multiple Choice',
        year: 2023,
      ),
    ];
  }

  List<Question> _getEnglishQuestions() {
    return [
      Question(
        id: 4,
        question: 'Choose the correct synonym for "benevolent".',
        options: ['Kind', 'Cruel', 'Selfish', 'Indifferent'],
        correctAnswer: 0,
        explanation:
            'Benevolent means well-meaning and kindly, which is synonymous with kind.',
        subject: 'English Language',
        topic: 'Vocabulary',
        examType: 'WAEC',
        questionType: 'Multiple Choice',
        year: 2023,
      ),
    ];
  }

  List<Question> _getPhysicsQuestions() {
    return [
      Question(
        id: 5,
        question: 'What is the SI unit of force?',
        options: ['Newton', 'Joule', 'Watt', 'Pascal'],
        correctAnswer: 0,
        explanation:
            'The SI unit of force is the Newton (N), named after Isaac Newton.',
        subject: 'Physics',
        topic: 'Mechanics',
        examType: 'WAEC',
        questionType: 'Multiple Choice',
        year: 2023,
      ),
    ];
  }
}
