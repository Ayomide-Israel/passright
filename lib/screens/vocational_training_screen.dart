import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/providers/navigation_provider.dart';
import 'package:passright/providers/vocational_provider.dart';
import 'package:passright/models/vocational_models.dart'; // Import the new models

class VocationalTrainingScreen extends ConsumerWidget {
  const VocationalTrainingScreen({super.key});

  void _handleStartSkill(WidgetRef ref, VocationalSkill skill) {
    ref.read(selectedSkillProvider.notifier).state = skill;
    ref.read(navigationProvider.notifier).state = AppScreen.skillDetail;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(252, 244, 242, 1),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 95),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(),
                        side: BorderSide(color: const Color.fromRGBO(0, 191, 166, 1), width: 2.0),
                        padding: const EdgeInsets.all(12),
                      ),
                      onPressed: () {
                        ref.read(navigationProvider.notifier).state = AppScreen.dashboard;
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
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color.fromRGBO(26, 61, 124, 1)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Learn a skill',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color.fromRGBO(107, 114, 128, 1)),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(color: const Color.fromRGBO(241, 242, 245, 1), shape: BoxShape.circle),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset('assets/images/logo6.png', scale: 5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Grid View
              Expanded(
                child: Container(
                  color: const Color.fromRGBO(241, 242, 245, 1),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Vocation Training', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color.fromRGBO(26, 61, 124, 1))),
                        const SizedBox(height: 15),
                        Expanded(
                          child: GridView.builder(
                            itemCount: vocationalSkills.length, // Use the list from models
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.75),
                            itemBuilder: (context, index) {
                              final skill = vocationalSkills[index];
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

  Widget _buildSkillCard(BuildContext context, WidgetRef ref, VocationalSkill skill) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              skill.gridImagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: Colors.grey[200], child: Center(child: Icon(Icons.image_not_supported, color: Colors.grey[400])));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(skill.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _handleStartSkill(ref, skill),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 191, 166, 1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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