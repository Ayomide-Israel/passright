// services/ai_service.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:passright/config/app_config.dart';
// 1. IMPORT THE LANGUAGE PROVIDER
import 'package:passright/providers/language_provider.dart';

class AIService {
  static const String _baseUrl = "https://router.huggingface.co/v1";
  final Dio _dio = Dio();
  final String apiKey;

  AIService({String? apiKey}) : apiKey = apiKey ?? AppConfig.apiKey;

  // 2. MODIFY THE FUNCTION TO ACCEPT THE LANGUAGE
  Future<String> getAIResponse(
    String message, {
    String? context,
    // Add the language parameter, defaulting to English
    AppLanguage language = AppLanguage.english,
  }) async {
    try {
      final String prompt = context != null
          ? "Context: $context\n\nUser Question: $message"
          : message;

      print('Sending request to Hugging Face API...'); // Debug log

      // Validate API key
      if (apiKey.isEmpty) {
        throw Exception('AI_API_KEY not configured');
      }

      // Ensure prompt has minimum content
      final String processedPrompt = prompt.trim().isEmpty
          ? "Please provide more details about what you'd like to learn."
          : prompt;

      // 3. GET THE LANGUAGE NAME
      // This uses the helper 'name' we created in the provider
      final String languageName = language.name;

      // 4. CREATE THE NEW DYNAMIC SYSTEM PROMPT
      final String systemPrompt =
          '''You are Diva AI, a helpful and patient tutor for Nigerian students.
You specialize in explaining academic concepts clearly and simply.
Always format your responses using Markdown for better readability.
Be encouraging and supportive in your tone.

***IMPORTANT INSTRUCTION***
YOU MUST respond in the following language: **$languageName**.
No matter what language the user asks in, your entire response must be in **$languageName**.
Do not add any preamble like "Here is the translation:". Just provide the response in **$languageName**.
''';

      final response = await _dio.post(
        '$_baseUrl/chat/completions',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
        ),
        data: jsonEncode({
          'model': 'deepseek-ai/DeepSeek-V3.1-Terminus:novita',
          'messages': [
            // 5. USE THE NEW SYSTEM PROMPT
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': processedPrompt},
          ],
          'max_tokens': 800,
          'temperature': 0.7,
        }),
      );

      print('API Response status: ${response.statusCode}'); // Debug log

      if (response.statusCode == 200) {
        final data = response.data;
        final content = data['choices'][0]['message']['content'];

        // Handle empty responses
        if (content == null || content.trim().isEmpty) {
          return "I'd be happy to help! Could you please provide more details about what you'd like to learn or which concept you need explained?";
        }

        // FIX: Safe substring to avoid RangeError
        final previewLength = content.length > 100 ? 100 : content.length;
        print(
          'AI Response received: ${content.substring(0, previewLength)}...',
        ); // Debug log
        return content;
      } else {
        throw Exception(
          'API error: ${response.statusCode} - ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('AI Service Error: $e'); // Debug log

      // Provide a helpful fallback response instead of rethrowing
      return "I'm here to help you learn! Please ask me any questions about your subjects, and I'll provide clear explanations to help you understand the concepts better.";
    }
  }
}