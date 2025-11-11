// screens/vocational_training_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/providers/navigation_provider.dart';
// 1. IMPORT THE NEW PROVIDER WE WILL CREATE
import 'package:passright/providers/vocational_provider.dart';

// --- 2. NEW DATA MODELS ---
// We need a model for the lessons
class Lesson {
  final String title;
  final String? duration; // e.g., "5 min"
  final String? content; // For expandable tiles
  final bool isExpandable;

  Lesson({
    required this.title,
    this.duration,
    this.content,
    this.isExpandable = false,
  });
}

// We update the main skill model to hold all the detail screen info
class VocationalSkill {
  final String title;
  final String gridImagePath; // Image for the grid (e.g., catering.png)
  final String
  detailImagePath; // Main image for the detail screen (e.g., catering_detail.png)
  final String introductionTitle;
  final String introductionDescription;
  final List<Lesson> lessons;
  final String? videoUrl; // Optional video URL

  VocationalSkill({
    required this.title,
    required this.gridImagePath,
    required this.detailImagePath,
    required this.introductionTitle,
    required this.introductionDescription,
    required this.lessons,
    this.videoUrl,
  });
}

// --- 3. UPDATED MOCK DATA ---
// We now fill in all the data for each skill
final List<VocationalSkill> skills = [
  VocationalSkill(
    title: 'Catering',
    gridImagePath: 'assets/images/catering.png', // From your file
    detailImagePath:
        'assets/images/catering_detail.png', // Main image from screenshot
    introductionTitle: 'Introduction to Catering',
    introductionDescription:
        'Learn the basics of culinary arts, kitchen management, and food preparation',
    videoUrl: 'https://www.youtube.com/watch?v=some_catering_video',
    lessons: [
      Lesson(title: 'Basic cooking techniques', duration: '5 min'),
      Lesson(
        title: 'Food Safety and Hygeine',
        isExpandable: true,
        content:
            'Detailed content about food safety, handling, storage, and hygiene protocols to prevent contamination.',
      ),
      Lesson(title: 'Kitchen Management', duration: '10 min'),
    ],
  ),
  VocationalSkill(
    title: 'Tailoring',
    gridImagePath: 'assets/images/tailoring.png', // From your file
    detailImagePath:
        'assets/images/tailoring_detail.png', // You'll need to add this
    introductionTitle: 'Introduction to Tailoring',
    introductionDescription:
        'Learn to cut, sew, and design basic garments and fabrics.',
    videoUrl: 'https://www.youtube.com/watch?v=some_tailoring_video',
    lessons: [
      Lesson(title: 'Understanding your Sewing Machine', duration: '15 min'),
      Lesson(
        title: 'Basic Stitches',
        isExpandable: true,
        content: 'Learn the running stitch, backstitch, and zigzag stitch.',
      ),
    ],
  ),
  VocationalSkill(
    title: 'ICT',
    gridImagePath: 'assets/images/ict.png', // From your file
    detailImagePath: 'assets/images/ict_detail.png', // You'll need to add this
    introductionTitle: 'Introduction to ICT',
    introductionDescription:
        'Understand computer hardware, software, and basic networking.',
    videoUrl: 'https://www.youtube.com/watch?v=some_ict_video',
    lessons: [
      Lesson(title: 'What is a Computer?', duration: '8 min'),
      Lesson(
        title: 'Hardware vs. Software',
        isExpandable: true,
        content:
            'Hardware is the physical parts of a computer. Software is the set of instructions that tells the hardware what to do.',
      ),
    ],
  ),
  VocationalSkill(
    title: 'Agriculture',
    gridImagePath: 'assets/images/agric.png', // From your file
    detailImagePath:
        'assets/images/agriculture_detail.png', // You'll need to add this
    introductionTitle: 'Introduction to Agriculture',
    introductionDescription:
        'Explore modern farming techniques, crop science, and soil management.',
    videoUrl: 'https://www.youtube.com/watch?v=some_agriculture_video',
    lessons: [
      Lesson(title: 'Understanding Soil Types', duration: '12 min'),
      Lesson(
        title: 'Crop Rotation',
        isExpandable: true,
        content:
            'Crop rotation is the practice of growing a series of different types of crops in the same area across a sequence of growing seasons.',
      ),
    ],
  ),
];

// 4. The Screen Widget
class VocationalTrainingScreen extends ConsumerWidget {
  const VocationalTrainingScreen({super.key});

  // --- 5. UPDATED NAVIGATION HANDLER ---
  void _handleStartSkill(WidgetRef ref, VocationalSkill skill) {
    // 1. Set the selected skill in a provider
    ref.read(selectedSkillProvider.notifier).state = skill;
    // 2. Navigate to the new detail screen
    ref.read(navigationProvider.notifier).state = AppScreen.skillDetail;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(
        252,
        244,
        242,
        1,
      ), // Your light background
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 6. Your Custom Header (unchanged)
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
                        shape: const CircleBorder(),
                        side: BorderSide(
                          color: const Color.fromRGBO(0, 191, 166, 1),
                          width: 2.0,
                        ),
                        padding: const EdgeInsets.all(12),
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
                            Text(
                              'Vocational \nTraining',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(26, 61, 124, 1),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Learn a skill',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(107, 114, 128, 1),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(241, 242, 245, 1),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              'assets/images/logo6.png',
                              scale: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),

              // 7. Your Grid View Section (mostly unchanged)
              Expanded(
                child: Container(
                  color: const Color.fromRGBO(241, 242, 245, 1),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vocation Training',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(26, 61, 124, 1),
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            itemCount: skills.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio:
                                      0.75, // Aspect ratio (width / height)
                                ),
                            itemBuilder: (context, index) {
                              final skill = skills[index];
                              // --- 8. PASS REF TO BUILDCARD ---
                              return _buildSkillCard(context, ref, skill);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 9. Skill Card Widget (UPDATED) ---
  Widget _buildSkillCard(
    BuildContext context,
    WidgetRef ref,
    VocationalSkill skill,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias, // Ensures image respects border radius
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              skill.gridImagePath, // Use grid image
              fit: BoxFit.cover,
              // Handle image errors gracefully
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      // Updated color to be visible on grey
                      color: Colors.grey[400],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // --- 10. UPDATE ONPRESSED ---
                    onPressed: () => _handleStartSkill(ref, skill),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(
                        0,
                        191,
                        166,
                        1,
                      ), // Teal
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Start Skill'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
