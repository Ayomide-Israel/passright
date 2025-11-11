// screens/language_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/providers/language_provider.dart';
import 'package:passright/providers/navigation_provider.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the provider to get the current language
    final currentLanguage = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(252, 244, 242, 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      ref.read(navigationProvider.notifier).state =
                          AppScreen.dashboard;
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Select Language',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(26, 61, 124, 1),
                    ),
                  ),
                ],
              ),
            ),
            
            // 3. List of languages
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Use RadioListTile for each language
                  _buildLanguageTile(
                    ref,
                    title: 'English',
                    value: AppLanguage.english,
                    groupValue: currentLanguage,
                  ),
                  _buildLanguageTile(
                    ref,
                    title: 'Igbo',
                    value: AppLanguage.igbo,
                    groupValue: currentLanguage,
                  ),
                  _buildLanguageTile(
                    ref,
                    title: 'Yorùbá',
                    value: AppLanguage.yoruba,
                    groupValue: currentLanguage,
                  ),
                  _buildLanguageTile(
                    ref,
                    title: 'Hausa',
                    value: AppLanguage.hausa,
                    groupValue: currentLanguage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for a styled RadioListTile
  Widget _buildLanguageTile(
    WidgetRef ref, {
    required String title,
    required AppLanguage value,
    required AppLanguage groupValue,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: value == groupValue
              ? const Color.fromRGBO(0, 191, 166, 1) // Active color
              : Colors.grey[300]!,
          width: value == groupValue ? 2.0 : 1.0,
        ),
      ),
      child: RadioListTile<AppLanguage>(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        value: value,
        groupValue: groupValue,
        onChanged: (AppLanguage? newValue) {
          if (newValue != null) {
            // 4. Update the provider when a new language is selected
            ref.read(languageProvider.notifier).state = newValue;
          }
        },
        activeColor: const Color.fromRGBO(0, 191, 166, 1),
      ),
    );
  }
}