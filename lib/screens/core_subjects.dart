// core_subjects.dart - CORRECTED
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/providers/navigation_provider.dart';
import 'package:passright/providers/resource_provider.dart';

class CoreSubjectScreen extends ConsumerStatefulWidget {
  const CoreSubjectScreen({super.key});

  @override
  ConsumerState<CoreSubjectScreen> createState() => _CoreSubjectScreenState();
}

class _CoreSubjectScreenState extends ConsumerState<CoreSubjectScreen> {
  String? selectedSubject;
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

  void _navigateToExploreResources() {
    if (selectedSubject != null) {
      // Set the filters for explore resources
      ref
          .read(exploreResourcesProvider.notifier)
          .setFilters(
            subject: selectedSubject!,
            topic: selectedTopic == 'All' ? null : selectedTopic,
          );
      ref.read(navigationProvider.notifier).state = AppScreen.exploreResources;
    } else {
      // Show error if no subject selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a subject first')),
      );
    }
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
                                'Core Subjects',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(26, 61, 124, 1),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Learn by topic in English, \nMath & Chemistry',
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
                                'assets/images/coresub.png',
                                scale: 2,
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
                            'Subjects',
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

                        // Topic Dropdown
                        const Text(
                          'Topic',
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
                  onPressed: _navigateToExploreResources,
                  child: const Text(
                    'EXPLORE RESOURCES',
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
