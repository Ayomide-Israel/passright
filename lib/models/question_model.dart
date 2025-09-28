// models/question_model.dart
class Question {
  final int id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
  final String subject;
  final String topic;
  final String examType;
  final String questionType;
  final int? year;
  final bool isAnswered; // Add this
  final int? userAnswer; // Add this
  final bool? isCorrect; // Add this

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.subject,
    required this.topic,
    required this.examType,
    required this.questionType,
    this.year,
    this.isAnswered = false, // Default to false
    this.userAnswer,
    this.isCorrect,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
      subject: json['subject'],
      topic: json['topic'],
      examType: json['examType'],
      questionType: json['questionType'],
      year: json['year'],
      isAnswered: json['isAnswered'] ?? false,
      userAnswer: json['userAnswer'],
      isCorrect: json['isCorrect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'subject': subject,
      'topic': topic,
      'examType': examType,
      'questionType': questionType,
      'year': year,
      'isAnswered': isAnswered,
      'userAnswer': userAnswer,
      'isCorrect': isCorrect,
    };
  }

  Question copyWith({
    int? id,
    String? question,
    List<String>? options,
    int? correctAnswer,
    String? explanation,
    String? subject,
    String? topic,
    String? examType,
    String? questionType,
    int? year,
    bool? isAnswered,
    int? userAnswer,
    bool? isCorrect,
  }) {
    return Question(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      subject: subject ?? this.subject,
      topic: topic ?? this.topic,
      examType: examType ?? this.examType,
      questionType: questionType ?? this.questionType,
      year: year ?? this.year,
      isAnswered: isAnswered ?? this.isAnswered,
      userAnswer: userAnswer ?? this.userAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}
