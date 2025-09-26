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
    };
  }
}
