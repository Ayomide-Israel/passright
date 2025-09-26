// screens/filter_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/providers/filter_provider.dart';
import 'package:passright/models/subject_model.dart';
import 'package:passright/screens/questions_detail.dart';

class FilterScreen extends ConsumerWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentScreen = ref.watch(currentScreenProvider);
    final filterState = ref.watch(filterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Questions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final screens = Filters.values;
            final currentIndex = screens.indexOf(currentScreen);

            if (currentIndex == 0) {
              Navigator.pop(context);
            } else {
              ref.read(currentScreenProvider.notifier).state =
                  screens[currentIndex - 1];
            }
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Study Past Questions',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Get all exam questions',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: _buildCurrentScreen(
              ref,
              currentScreen,
              filterState,
              context,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen(
    WidgetRef ref,
    Filters currentScreen,
    FilterState filterState,
    BuildContext context,
  ) {
    switch (currentScreen) {
      case Filters.subject:
        return _buildSubjectScreen(ref);
      case Filters.examType:
        return _buildExamTypeScreen(ref, filterState);
      case Filters.questionType:
        return _buildQuestionTypeScreen(ref, filterState);
      case Filters.topic:
        return _buildTopicScreen(ref, filterState);
      case Filters.questions:
        return _buildQuestionsScreen(ref, filterState, context);
    }
  }

  Widget _buildSubjectScreen(WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Subject',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...subjects.map((subject) {
          return ListTile(
            leading: Icon(Icons.subject, size: 40), // Placeholder icon
            title: Text(subject.name),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ref.read(filterProvider.notifier).setSubject(subject.name);
              ref.read(currentScreenProvider.notifier).state = Filters.examType;
            },
          );
        }),
      ],
    );
  }

  Widget _buildExamTypeScreen(WidgetRef ref, FilterState filterState) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSelectedOption('Subject', filterState.subject),
        const SizedBox(height: 24),
        const Text(
          'Examination Type',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...examTypes.map((examType) {
          return ListTile(
            title: Text(examType.name),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ref.read(filterProvider.notifier).setExamType(examType.name);
              ref.read(currentScreenProvider.notifier).state =
                  Filters.questionType;
            },
          );
        }),
      ],
    );
  }

  Widget _buildQuestionTypeScreen(WidgetRef ref, FilterState filterState) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSelectedOption('Subject', filterState.subject),
        _buildSelectedOption('Examination Type', filterState.examType),
        const SizedBox(height: 24),
        const Text(
          'Question Type',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...questionTypes.map((questionType) {
          return ListTile(
            title: Text(questionType.name),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ref
                  .read(filterProvider.notifier)
                  .setQuestionType(questionType.name);
              ref.read(currentScreenProvider.notifier).state = Filters.topic;
            },
          );
        }),
      ],
    );
  }

  Widget _buildTopicScreen(WidgetRef ref, FilterState filterState) {
    // Filter topics by selected subject
    final subject = subjects.firstWhere(
      (s) => s.name == filterState.subject,
      orElse: () => Subject(id: '', name: '', icon: ''),
    );

    final subjectTopics = topics
        .where((topic) => topic.subjectId == subject.id)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSelectedOption('Subject', filterState.subject),
        _buildSelectedOption('Examination Type', filterState.examType),
        _buildSelectedOption('Question Type', filterState.questionType),
        const SizedBox(height: 24),
        const Text(
          'Question Topic',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // "All" option
        ListTile(
          title: const Text('All'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ref.read(filterProvider.notifier).setTopic('All');
            ref.read(currentScreenProvider.notifier).state = Filters.questions;
          },
        ),
        // Topic options
        ...subjectTopics.map((topic) {
          return ListTile(
            title: Text(topic.name),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ref.read(filterProvider.notifier).setTopic(topic.name);
              ref.read(currentScreenProvider.notifier).state =
                  Filters.questions;
            },
          );
        }),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ref.read(currentScreenProvider.notifier).state =
                  Filters.questions;
            },
            child: const Text('START PRACTICE'),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionsScreen(
    WidgetRef ref,
    FilterState filterState,
    BuildContext context,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSelectedOption('Subject', filterState.subject),
              _buildSelectedOption('Examination Type', filterState.examType),
              _buildSelectedOption('Question Type', filterState.questionType),
              _buildSelectedOption('Topic', filterState.topic),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search Question',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  ref.read(filterProvider.notifier).setSearchQuery(value);
                },
              ),
            ],
          ),
        ),
        Expanded(child: _buildQuestionsList(ref, context)),
      ],
    );
  }

  Widget _buildQuestionsList(WidgetRef ref, BuildContext context) {
    // In a real app, this would fetch questions based on filters
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildQuestionItem(
          context: context,
          number: 1,
          question: 'If 3x - 4 = 11, find the value of x.',
          options: ['3', '4', '5', '7'],
          correctAnswer: 2,
          explanation: 'Add 4 to both sides: 3x = 15. Then divide by 3: x = 5.',
        ),
        _buildQuestionItem(
          context: context,
          number: 2,
          question: 'Simplify: 2(x + 3) - 3(x - 1)',
          options: ['-x + 9', 'x + 9', '-x + 3', 'x + 3'],
          correctAnswer: 0,
          explanation: 'Expand: 2x + 6 - 3x + 3 = -x + 9',
        ),
      ],
    );
  }

  Widget _buildQuestionItem({
    required BuildContext context,
    required int number,
    required String question,
    required List<String> options,
    required int correctAnswer,
    required String explanation,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to question detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionDetailScreen(
              questionNumber: number,
              question: question,
              options: options,
              correctAnswer: correctAnswer,
              explanation: explanation,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question $number',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(question),
              const SizedBox(height: 16),
              ...options.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('${String.fromCharCode(65 + index)}. $option'),
                );
              }),
              const SizedBox(height: 16),
              const Text(
                'View Explanation',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedOption(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value ?? 'Select $label'),
        ],
      ),
    );
  }
}
