// filter.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/providers/navigation_provider.dart';
import 'package:passright/providers/filter_provider.dart'; // Add this import

class FiltersScreen extends ConsumerStatefulWidget {
  const FiltersScreen({super.key});

  @override
  ConsumerState<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends ConsumerState<FiltersScreen> {
  String? selectedSubject;
  String? selectedExamType;
  String? selectedQuestionType;
  String? selectedTopic;

  final List<String> subjects = [
    'Mathematics',
    'English Language',
    'Physics',
    'Chemistry',
    'Biology',
    'Economics',
    'Literature',
    'Government',
    'Geography',
    'History',
  ];

  final List<String> examTypes = [
    'WAEC',
    'JAMB',
    'NECO',
    'GCE',
    'Post-UTME',
    'NABTEB',
  ];

  final List<String> questionTypes = [
    'Multiple Choice',
    'Theory',
    'Practical',
    'Mixed',
  ];

  final List<String> topics = [
    'All',
    'Algebra',
    'Calculus',
    'Geometry',
    'Organic Chemistry',
    'Inorganic Chemistry',
    'Mechanics',
    'Electricity',
    'Genetics',
    'Ecology',
  ];

  void _startPractice() {
    // Validate required fields using && operator in a single condition
    if (selectedSubject == null || selectedExamType == null) {
      String errorMessage = 'Please select ';

      if (selectedSubject == null && selectedExamType == null) {
        errorMessage += 'both subject and exam type';
      } else if (selectedSubject == null) {
        errorMessage += 'a subject';
      } else {
        errorMessage += 'an exam type';
      }

      errorMessage += ' to continue';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    }

    // Save filters to provider
    ref.read(filterProvider.notifier).setSubject(selectedSubject!);
    ref.read(filterProvider.notifier).setExamType(selectedExamType!);

    if (selectedQuestionType != null) {
      ref.read(filterProvider.notifier).setQuestionType(selectedQuestionType!);
    }

    if (selectedTopic != null) {
      ref.read(filterProvider.notifier).setTopic(selectedTopic!);
    }

    // Only navigate if validation passes
    ref.read(navigationProvider.notifier).state = AppScreen.practiceSession;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(252, 244, 242, 1),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    top: 95,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        style: OutlinedButton.styleFrom(
                          shape: CircleBorder(),
                          side: BorderSide(
                            color: Color.fromRGBO(0, 191, 166, 1),
                            width: 2.0,
                          ),
                          padding: EdgeInsets.all(12),
                        ),
                        onPressed: () {
                          ref.read(navigationProvider.notifier).state =
                              AppScreen.dashboard;
                        },
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Study Past Questions',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(26, 61, 124, 1),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Get all exam questions',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                'assets/images/logo3.png',
                                scale: 5,
                                color: Color.fromRGBO(0, 191, 166, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),

                Container(
                  color: Color.fromRGBO(241, 242, 245, 1),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 70,
                      left: 20,
                      right: 20,
                      top: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Container(
                          alignment: Alignment.center,
                          height: 58,
                          width: 127,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                          child: const Text(
                            'Questions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(26, 61, 124, 1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Subject Dropdown
                        const Text(
                          'Subject',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromRGBO(217, 217, 217, 1),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: selectedSubject,
                            dropdownColor: Color.fromRGBO(252, 244, 242, 1),
                            borderRadius: BorderRadius.circular(16),
                            hint: const Text('Select Subject'),
                            iconSize: 35,
                            isExpanded: true,
                            underline: const SizedBox(),
                            items: subjects.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedSubject = newValue;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Examination Type Dropdown
                        const Text(
                          'Examination Type',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromRGBO(217, 217, 217, 1),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: selectedExamType,
                            hint: const Text('Select Examination Type'),
                            iconSize: 35,
                            isExpanded: true,
                            underline: const SizedBox(),
                            items: examTypes.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedExamType = newValue;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Question Type Dropdown
                        const Text(
                          'Question Type',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromRGBO(217, 217, 217, 1),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: selectedQuestionType,
                            hint: const Text('Select Question Type'),
                            iconSize: 35,
                            isExpanded: true,
                            underline: const SizedBox(),
                            items: questionTypes.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedQuestionType = newValue;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Topic Dropdown
                        const Text(
                          'Question Topic',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromRGBO(217, 217, 217, 1),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: selectedTopic,
                            hint: const Text('All'),
                            iconSize: 35,
                            iconDisabledColor: Color.fromRGBO(176, 176, 176, 1),
                            isExpanded: true,
                            underline: const SizedBox(),
                            items: topics.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedTopic = newValue;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Positioned button at the bottom
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              alignment: Alignment.center,
              color: Color.fromRGBO(241, 242, 245, 1),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                width: 374,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(0, 191, 166, 1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _startPractice, // Use the validation function
                  child: const Text(
                    'START PRACTICE',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
