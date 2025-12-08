import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/providers/navigation_provider.dart';
import 'package:passright/providers/vocational_provider.dart';
import 'package:passright/models/vocational_models.dart';

class SkillDetailScreen extends ConsumerWidget {
  const SkillDetailScreen({super.key});

  void _navigateToLesson(WidgetRef ref, Lesson lesson) {
    ref.read(currentLessonProvider.notifier).state = lesson;
    ref.read(navigationProvider.notifier).state = AppScreen.lessonContent;
  }

  void _showStartLearningOptions(BuildContext context, WidgetRef ref, VocationalSkill skill) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'How do you want to learn?',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(26, 61, 124, 1)),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'You can start with online video lessons or connect with a local mentor for hands-on training.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          actions: [
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      if (skill.lessons.isNotEmpty) {
                        _navigateToLesson(ref, skill.lessons[0]);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No online lessons available yet.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 191, 166, 1), // Teal
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Go to Courses'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      
                      // CORRECTED LOGIC: Navigate directly to the Connect Screen
                      // Do NOT set dashboard index to 2 (which is the Hub)
                      ref.read(navigationProvider.notifier).state = AppScreen.mentorList;
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color.fromRGBO(26, 61, 124, 1), // Navy
                      side: const BorderSide(color: Color.fromRGBO(26, 61, 124, 1)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Find a Mentor'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skill = ref.watch(selectedSkillProvider);

    if (skill == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No skill selected. Please go back.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 250, 252),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  Expanded(
                    child: Text(
                      skill.title, 
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(26, 61, 124, 1),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            skill.detailImagePath, 
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
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.play_arrow,
                                color: Colors.white, size: 40),
                            onPressed: () => _showStartLearningOptions(context, ref, skill),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Text(
                      skill.introductionTitle, 
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(26, 61, 124, 1),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      skill.introductionDescription, 
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Lessons',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(26, 61, 124, 1),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: skill.lessons.length,
                      itemBuilder: (context, index) {
                        final lesson = skill.lessons[index];
                        return _buildLessonItem(context, ref, lesson);
                      },
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showStartLearningOptions(context, ref, skill),
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

  Widget _buildLessonItem(BuildContext context, WidgetRef ref, Lesson lesson) {
    // ... (Keep existing implementation for _buildLessonItem)
    if (lesson.isExpandable) {
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ExpansionTile(
          title: Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.arrow_drop_down),
          children: [
            Padding(
              padding: const EdgeInsets.all(16).copyWith(top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lesson.content ?? 'No content available.', style: const TextStyle(color: Colors.black54, height: 1.4)),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _navigateToLesson(ref, lesson),
                      child: const Text("Go to Lesson", style: TextStyle(color: Color.fromRGBO(0, 191, 166, 1))),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Text(lesson.duration ?? '', style: const TextStyle(color: Colors.grey)),
        onTap: () => _navigateToLesson(ref, lesson),
      ),
    );
  }
}