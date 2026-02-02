// chat_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/features/academic/models/question_model.dart';
import 'package:passright/features/resources/models/resource_model.dart';

class ChatContext {
  final Question? question;
  final String? subject;
  final String? topic;
  final EducationalVideo? video;

  const ChatContext({this.question, this.subject, this.topic, this.video});
}

enum ChatSource { dashboard, explanation, resources, video, grid }

final chatContextProvider = StateProvider<ChatContext?>((ref) => null);

final chatNavigationSourceProvider = StateProvider<ChatSource>(
  (ref) => ChatSource.dashboard,
);
