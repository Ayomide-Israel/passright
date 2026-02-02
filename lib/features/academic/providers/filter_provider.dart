// providers/filter_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Filters { subject, examType, questionType, topic, questions }

// Filter state model
class FilterState {
  final String? subject;
  final String? examType;
  final String? questionType;
  final String? topic;
  final String? searchQuery;

  FilterState({
    this.subject,
    this.examType,
    this.questionType,
    this.topic,
    this.searchQuery,
  });

  FilterState copyWith({
    String? subject,
    String? examType,
    String? questionType,
    String? topic,
    String? searchQuery,
  }) {
    return FilterState(
      subject: subject ?? this.subject,
      examType: examType ?? this.examType,
      questionType: questionType ?? this.questionType,
      topic: topic ?? this.topic,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// Filter provider
final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>((
  ref,
) {
  return FilterNotifier();
});

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(FilterState());

  void setSubject(String subject) {
    state = state.copyWith(subject: subject);
  }

  void setExamType(String examType) {
    state = state.copyWith(examType: examType);
  }

  void setQuestionType(String questionType) {
    state = state.copyWith(questionType: questionType);
  }

  void setTopic(String topic) {
    state = state.copyWith(topic: topic);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void reset() {
    state = FilterState();
  }
}

// Current screen provider for filter workflow
final currentScreenProvider = StateProvider<Filters>((ref) => Filters.subject);
