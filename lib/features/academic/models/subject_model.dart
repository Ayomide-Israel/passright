// models/subject_model.dart
class Subject {
  final String id;
  final String name;
  final String icon;

  Subject({required this.id, required this.name, required this.icon});
}

class ExamType {
  final String id;
  final String name;

  ExamType({required this.id, required this.name});
}

class QuestionType {
  final String id;
  final String name;

  QuestionType({required this.id, required this.name});
}

class Topic {
  final String id;
  final String name;
  final String subjectId;

  Topic({required this.id, required this.name, required this.subjectId});
}

// Mock data
final List<Subject> subjects = [
  Subject(id: '1', name: 'Mathematics', icon: 'assets/images/math_icon.png'),
  Subject(
    id: '2',
    name: 'English Language',
    icon: 'assets/images/english_icon.png',
  ),
  Subject(id: '3', name: 'Chemistry', icon: 'assets/images/chemistry_icon.png'),
  Subject(id: '4', name: 'Physics', icon: 'assets/images/physics_icon.png'),
];

final List<ExamType> examTypes = [
  ExamType(id: '1', name: 'JAMB'),
  ExamType(id: '2', name: 'WAEC'),
  ExamType(id: '3', name: 'NECO'),
  ExamType(id: '4', name: 'Post-UTME'),
];

final List<QuestionType> questionTypes = [
  QuestionType(id: '1', name: 'Objective'),
  QuestionType(id: '2', name: 'Theory'),
  QuestionType(id: '3', name: 'Practical'),
];

final List<Topic> topics = [
  Topic(id: '1', name: 'Algebra', subjectId: '1'),
  Topic(id: '2', name: 'Number Bases', subjectId: '1'),
  Topic(id: '3', name: 'Indices', subjectId: '1'),
  Topic(id: '4', name: 'Surds', subjectId: '1'),
  Topic(id: '5', name: 'Logic', subjectId: '1'),
  Topic(id: '6', name: 'Sets', subjectId: '1'),
  Topic(id: '7', name: 'Numbers and Numeration', subjectId: '1'),
  Topic(id: '8', name: 'Grammar', subjectId: '2'),
  Topic(id: '9', name: 'Comprehension', subjectId: '2'),
  Topic(id: '10', name: 'Essay Writing', subjectId: '2'),
];
