// services/ai_service.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:passright/config/app_config.dart';
import 'package:passright/providers/language_provider.dart';

class AIService {
  static const String _baseUrl = "https://router.huggingface.co/v1";
  final Dio _dio = Dio();
  final String apiKey;

  AIService({String? apiKey}) : apiKey = apiKey ?? AppConfig.apiKey;

  Future<String> getAIResponse(String message, {String? context, required AppLanguage language}) async {
    try {
      final String prompt = context != null
          ? "Context: $context\n\nUser Question: $message"
          : message;

      print('Sending request to Hugging Face API...');
      print('🌍 Requested language: ${_getLanguageName(language)}'); // Debug log

      // Validate API key
      if (apiKey.isEmpty) {
        throw Exception('AI_API_KEY not configured');
      }

      // Ensure prompt has minimum content
      final String processedPrompt = prompt.trim().isEmpty 
          ? "Please provide more details about what you'd like to learn."
          : prompt;

      // FIX: Create language-specific system prompt
      final String systemPrompt = _buildSystemPrompt(language);

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
            {
              'role': 'system',
              'content': systemPrompt, // Use the language-specific prompt
            },
            {'role': 'user', 'content': processedPrompt},
          ],
          'max_tokens': 800,
          'temperature': 0.7,
        }),
      );

      print('API Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        final content = data['choices'][0]['message']['content'];
        
        // Handle empty responses
        if (content == null || content.trim().isEmpty) {
          return _getEmptyResponseMessage(language);
        }
        
        // FIX: Safe substring to avoid RangeError
        final previewLength = content.length > 100 ? 100 : content.length;
        print(
          'AI Response received: ${content.substring(0, previewLength)}...',
        );
        return content;
      } else {
        throw Exception(
          'API error: ${response.statusCode} - ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('AI Service Error: $e');
      
      // Provide a helpful fallback response in the correct language
      return _getErrorMessage(language);
    }
  }

  // FIX: Add helper methods for language-specific content
  String _buildSystemPrompt(AppLanguage language) {
    final String languageInstruction = _getLanguageInstruction(language);
    
    return '''You are Diva AI, a helpful and patient tutor for Nigerian students preparing for exams like WAEC, JAMB, NECO, etc. 
You specialize in explaining academic concepts clearly and simply. 
$languageInstruction
Always format your responses using Markdown for better readability.
Be encouraging and supportive in your tone. Focus on the underlying concepts.
Keep responses concise but comprehensive.''';
  }

  String _getLanguageInstruction(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'Respond in English.';
      case AppLanguage.yoruba:
        return 'Jẹ ki o dahun ni èdè Yorùbá. Maṣe lo Markdown, ṣe afiwe rẹ ni ọna ti o rọrun lati laakaye.';
      case AppLanguage.igbo:
        return 'Zaa n\'asụsụ Igbo. Ejila Markdown, kọwaa ihe ị na-ekwu n\'ụzọ dị mfe nghọta.';
      case AppLanguage.hausa:
        return 'Amsa cikin harshen Hausa. Kar ka yi amfani da Markdown, ka bayyana abubuwa cikin sauƙi.';
    }
  }

  String _getEmptyResponseMessage(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return "I'd be happy to help! Could you please provide more details about what you'd like to learn or which concept you need explained?";
      case AppLanguage.yoruba:
        return "Mo wà láti ran yín lọ́wọ́! Ẹ jọ̀wọ́ ẹ le ṣe àlàyé díẹ̀ sí i nipa ohun tí ẹ fẹ́ kọ́ tàbí èròǹgà tí ẹ nilo ìtumọ̀ rẹ̀?";
      case AppLanguage.igbo:
        return "A dị m njikere inyere gị aka! Biko ị nwere ike ịkọwakwu ihe ị chọrọ ịmụ ma ọ bụ echiche ị chọrọ nkọwa?";
      case AppLanguage.hausa:
        return "Ina nan don taimaka muku! Don Allah za ku iya ba da ƙarin bayani game da abin da kuke son koyo ko kuma ra'ayin da kuke buƙatar bayani?";
    }
  }

  String _getErrorMessage(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return "I'm here to help you learn! Please ask me any questions about your subjects, and I'll provide clear explanations to help you understand the concepts better.";
      case AppLanguage.yoruba:
        return "Mo wà láti ran yín lọ́wọ́ láti kọ́! Ẹ jọ̀wọ́ ẹ beère ìbeère nipa ẹ̀kọ́ yín, èmi á sì fún yín ní àlàyé tó yẹn júlo láti ran yín lọ́wọ́ láti gbọ̀ràn èròǹgà yẹn dára.";
      case AppLanguage.igbo:
        return "Anọ m ebe a iji nyere gị aka ịmụ ihe! Biko jụọ m ajụjụ ọ bụla gbasara isiokwu gị, m ga-enye nkọwa doro anya iji nyere gị aka ịghọta echiche ndị ahụ nke ọma.";
      case AppLanguage.hausa:
        return "Ina nan don taimaka muku koyo! Don Allah yi min tambayoyi game da batutuwan ku, kuma zan ba da bayanai masu haske don taimaka muku fahimtar ra'ayoyin.";
    }
  }

  String _getLanguageName(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.yoruba:
        return 'Yoruba';
      case AppLanguage.igbo:
        return 'Igbo';
      case AppLanguage.hausa:
        return 'Hausa';
    }
  }
}