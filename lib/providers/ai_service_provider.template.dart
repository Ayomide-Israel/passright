import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ai_service.dart';
import '../config/app_config.dart';

final aiServiceProvider = Provider<AIService>((ref) {
  throw Exception(
    'AIService not initialized. Call initializeAIService() first.',
  );
});

final aiServiceInitializerProvider = Provider<Future<AIService>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 100));

  return AIService(apiKey: AppConfig.apiKey);
});
