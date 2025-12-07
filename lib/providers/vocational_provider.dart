import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/models/vocational_models.dart';

// 1. Holds the specific skill category the user selected
final selectedSkillProvider = StateProvider<VocationalSkill?>((ref) => null);

// 2. Holds the specific lesson the user is currently viewing
final currentLessonProvider = StateProvider<Lesson?>((ref) => null);

// 3. Holds the list of mentors for the Community Screen
final mentorListProvider = Provider<List<Mentor>>((ref) {
  return mockMentors;
});

// 4. NEW: Holds the specific mentor selected from the Community list
final selectedMentorProvider = StateProvider<Mentor?>((ref) => null);