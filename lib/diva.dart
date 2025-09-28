import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:passright/providers/navigation_provider.dart';
import 'package:passright/services/ai_service.dart';
import 'package:passright/services/chat_storage_service.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,

            child: const Text('AI'),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Typing...',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ChatUser _currentUser = ChatUser(id: '1', firstName: 'Student');
  final ChatUser _divaUser = ChatUser(id: '2', firstName: 'Diva AI');
  final List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];
  bool _hasSentInitialMessage = false;
  final ChatStorageService _storageService = ChatStorageService();
  String _chatContext = '';

  @override
  void initState() {
    super.initState();
    _loadMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendInitialMessage();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final savedMessages = await _storageService.loadMessages();
    if (mounted) {
      setState(() {
        _messages.addAll(savedMessages);
        // Build context from previous messages
        _chatContext = savedMessages
            .where((msg) => msg.user.id == _divaUser.id)
            .map((msg) => msg.text)
            .join('\n\n');
      });
    }
  }

  void _sendInitialMessage() {
    final chatContext = ref.read(chatContextProvider);

    if (chatContext != null && !_hasSentInitialMessage) {
      final initialMessage =
          """
Please explain this question and the underlying concept in detail:

Subject: ${chatContext.subject}
Topic: ${chatContext.topic}
Question: ${chatContext.question.question}
Options: ${chatContext.question.options.asMap().entries.map((e) => '${String.fromCharCode(65 + e.key)}. ${e.value}').join(', ')}
Correct Answer: ${String.fromCharCode(65 + chatContext.question.correctAnswer)}. ${chatContext.question.options[chatContext.question.correctAnswer]}

Please provide a comprehensive explanation of the concept behind this question.
""";

      _sendMessage(
        ChatMessage(
          user: _currentUser,
          createdAt: DateTime.now(),
          text: initialMessage,
        ),
      );
      _hasSentInitialMessage = true;
    }
  }

  void _handleSendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      _sendMessage(
        ChatMessage(user: _currentUser, createdAt: DateTime.now(), text: text),
      );
      _textController.clear();
    }
  }

  Future<void> _sendMessage(ChatMessage message) async {
    setState(() {
      _messages.insert(0, message);
      _typingUsers = [_divaUser];
    });
    await _storageService.saveMessages(_messages);
    await _fetchAIResponse(message.text);
  }

  Future<void> _fetchAIResponse(String inputText) async {
    try {
      final aiService = AIService();

      setState(() {
        _typingUsers = [_divaUser];
      });

      final contextualPrompt =
          '''
Previous context:
$_chatContext

Current question:
$inputText
''';

      final response = await aiService.getAIResponse(contextualPrompt);
      print(
        'AI Response received: ${response.substring(0, 50)}...',
      ); // Debug log

      if (mounted) {
        final divaChatMessage = ChatMessage(
          user: _divaUser,
          createdAt: DateTime.now(),
          text: response,
        );

        setState(() {
          _messages.insert(0, divaChatMessage);
          _typingUsers = [];
          _chatContext += '\n\n${divaChatMessage.text}';
        });
        await _storageService.saveMessages(_messages);
      }
    } catch (e) {
      print('Error in _fetchAIResponse: $e'); // Debug log

      if (mounted) {
        final errorMessage = _getErrorMessage(e);
        final errorChatMessage = ChatMessage(
          user: _divaUser,
          createdAt: DateTime.now(),
          text: errorMessage,
        );

        setState(() {
          _messages.insert(0, errorChatMessage);
          _typingUsers = [];
        });
        await _storageService.saveMessages(_messages);
      }
    }
  }

  String _getErrorMessage(dynamic error) {
    final errorString = error.toString();

    if (errorString.contains('403')) {
      return """
🔒 **Authentication Issue**

I'm having trouble connecting to my knowledge base right now.

${_getFallbackResponse("")}
""";
    }

    if (errorString.contains('429')) {
      return """
⏳ **Too Many Requests**

Please wait a moment and try again.

${_getFallbackResponse("")}
""";
    }

    return """
⚠️ **Temporary Issue**

I'm experiencing a technical difficulty. Please try again.

${_getFallbackResponse("")}
""";
  }

  // Update the math formatting in _getFallbackResponse
  String _getFallbackResponse(String inputText) {
    if (inputText.contains('3x') && inputText.contains('4 = 11')) {
      return """
**Step 1: Understanding the Equation**
`3x - 4 = 11`

**Step 2: Isolate the variable**
- Add 4 to both sides:
  `3x - 4 + 4 = 11 + 4`
  `3x = 15`
- Divide both sides by 3:
  `3x ÷ 3 = 15 ÷ 3`
  `x = 5`

**Verification:**
- Substitute x = 5 back:
  `3(5) - 4 = 11`
  `15 - 4 = 11`
  `11 = 11` ✓

**Therefore:** The answer is `x = 5`
""";
    }

    return """
**General Study Tips:**
- Read questions carefully
- Break problems into steps
- Check your work""";
  }

  void _handleBackButton() {
    final source = ref.read(chatNavigationSourceProvider);

    if (source == ChatSource.explanation) {
      // Go back to the explanation screen
      ref.read(navigationProvider.notifier).state = AppScreen.practiceSession;
    } else {
      // Go back to dashboard
      ref.read(navigationProvider.notifier).state = AppScreen.dashboard;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatContext = ref.watch(chatContextProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Diva AI Tutor'),
            if (chatContext != null)
              Text(
                '${chatContext.subject} - ${chatContext.topic}',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBackButton,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length + (_typingUsers.isNotEmpty ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == 0 && _typingUsers.isNotEmpty) {
                  return const TypingIndicator();
                }

                final messageIndex = _typingUsers.isNotEmpty
                    ? index - 1
                    : index;
                final message = _messages[messageIndex];
                final isAI = message.user.id == _divaUser.id;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Column(
                    crossAxisAlignment: isAI
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth:
                              MediaQuery.of(context).size.width *
                              0.75, // 75% of screen width
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isAI
                              ? const Color.fromARGB(255, 229, 231, 229)
                              : const Color(
                                  0xFF00695C,
                                ), // Blue for user messages
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: isAI
                                ? Radius.zero
                                : const Radius.circular(12),
                            bottomRight: isAI
                                ? const Radius.circular(12)
                                : Radius.zero,
                          ),
                        ),
                        child: isAI
                            ? MarkdownBody(
                                data: message.text,
                                styleSheet: MarkdownStyleSheet(
                                  p: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                  h1: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  h2: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  h3: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  listBullet: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  code: const TextStyle(
                                    color: Colors.black,
                                    backgroundColor: Color.fromARGB(
                                      50,
                                      0,
                                      0,
                                      0,
                                    ),
                                    fontSize: 16,
                                    fontFamily: 'monospace',
                                  ),
                                  blockquote: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                selectable: true,
                              )
                            : Text(
                                message.text,
                                style: const TextStyle(color: Colors.white),
                              ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: isAI
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        children: [
                          if (isAI) ...[
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: const Color(0xFF00695C),
                              child: const Text(
                                'AI',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ] else ...[
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: const Color.fromARGB(
                                255,
                                229,
                                231,
                                229,
                              ),
                              child: const Text(
                                'You',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 16.0, // Increased bottom padding
              top: 4.0, // Reduced top padding
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Ask follow-up questions...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 229, 231, 229),
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 229, 231, 229),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 229, 231, 229),
                            width: 1.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      onSubmitted: (_) => _handleSendMessage(),
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send_rounded),
                    onPressed: _handleSendMessage,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
