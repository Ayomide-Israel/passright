// screens/skill_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/providers/navigation_provider.dart';
import 'package:passright/providers/vocational_provider.dart';
import 'package:passright/screens/vocational_training_screen.dart';

class SkillDetailScreen extends ConsumerWidget {
  const SkillDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the provider to get the selected skill
    final skill = ref.watch(selectedSkillProvider);

    // 2. Handle the case where no skill is selected (e.g., app bug)
    if (skill == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('No skill selected. Please go back.'),
        ),
      );
    }

    // 3. Build the UI
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 250, 252),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 4. Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      ref.read(navigationProvider.notifier).state =
                          AppScreen.vocationalTraining;
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    skill.title, // Dynamic title
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(26, 61, 124, 1),
                    ),
                  ),
                ],
              ),
            ),

            // 5. Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video/Image with Play Button
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            skill.detailImagePath, // Dynamic image
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.grey[200],
                                child: Center(
                                  child: Icon(Icons.image_not_supported,
                                      color: Colors.grey[400]),
                                ),
                              );
                            },
                          ),
                        ),
                        // Play Button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.play_arrow,
                                color: Colors.white, size: 40),
                            onPressed: () {
                              // TODO: Implement video player logic
                              print('Play video: ${skill.videoUrl}');
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Introduction Text
                    Text(
                      skill.introductionTitle, // Dynamic intro
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(26, 61, 124, 1),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      skill.introductionDescription, // Dynamic description
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Lessons Section
                    const Text(
                      'Lessons',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(26, 61, 124, 1),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Build the list of lessons
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: skill.lessons.length,
                      itemBuilder: (context, index) {
                        final lesson = skill.lessons[index];
                        return _buildLessonItem(context, lesson);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 6. Bottom "START LEARNING" Button
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement start learning logic
                  print('Start Learning ${skill.title}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 191, 166, 1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'START LEARNING',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build the lesson items
  Widget _buildLessonItem(BuildContext context, Lesson lesson) {
    // If it's expandable, use ExpansionTile
    if (lesson.isExpandable) {
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ExpansionTile(
          title: Text(lesson.title,
              style: const TextStyle(fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.arrow_drop_down),
          children: [
            Padding(
              padding: const EdgeInsets.all(16).copyWith(top: 0),
              child: Text(
                lesson.content ?? 'No content available.',
                style: const TextStyle(color: Colors.black54, height: 1.4),
              ),
            ),
          ],
        ),
      );
    }

    // Otherwise, use a simple Card/ListTile
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(lesson.title,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Text(
          lesson.duration ?? '',
          style: const TextStyle(color: Colors.grey),
        ),
        onTap: () {
          // TODO: Navigate to lesson
          print('Tapped lesson: ${lesson.title}');
        },
      ),
    );
  }
}