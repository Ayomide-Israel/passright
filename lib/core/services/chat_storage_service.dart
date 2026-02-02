import 'package:dash_chat_2/dash_chat_2.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ChatStorageService {
  static const String _messageKey = 'chat_messages';

  Future<void> saveMessages(List<ChatMessage> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = messages
        .map(
          (msg) => {
            'text': msg.text,
            'userId': msg.user.id,
            'userName': msg.user.firstName,
            'createdAt': msg.createdAt.toIso8601String(),
          },
        )
        .toList();
    await prefs.setString(_messageKey, jsonEncode(messagesJson));
  }

  Future<List<ChatMessage>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? messagesString = prefs.getString(_messageKey);
    if (messagesString == null) return [];

    final List<dynamic> messagesJson = jsonDecode(messagesString);
    return messagesJson
        .map(
          (json) => ChatMessage(
            text: json['text'],
            user: ChatUser(id: json['userId'], firstName: json['userName']),
            createdAt: DateTime.parse(json['createdAt']),
          ),
        )
        .toList();
  }
}
