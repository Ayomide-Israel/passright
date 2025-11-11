// providers/vocational_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/screens/vocational_training_screen.dart';

// This provider will hold the skill that the user tapped on.
final selectedSkillProvider = StateProvider<VocationalSkill?>((ref) => null);