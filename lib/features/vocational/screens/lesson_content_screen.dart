import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/core/providers/navigation_provider.dart';
import 'package:passright/features/vocational/providers/vocational_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonContentScreen extends ConsumerStatefulWidget {
  const LessonContentScreen({super.key});

  @override
  ConsumerState<LessonContentScreen> createState() => _LessonContentScreenState();
}

class _LessonContentScreenState extends ConsumerState<LessonContentScreen> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    // Default video ID for demo purposes since we didn't add video IDs to every lesson model yet
    // In a real app, use: widget.lesson.videoId
    const String videoId = 'NybHckSEQBI'; 

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = ref.watch(currentLessonProvider);
    final skill = ref.watch(selectedSkillProvider);

    if (lesson == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromRGBO(26, 61, 124, 1)),
          onPressed: () {
            ref.read(navigationProvider.notifier).state = AppScreen.skillDetail;
          },
        ),
        title: Text(
          skill?.title ?? 'Lesson',
          style: const TextStyle(
            color: Color.fromRGBO(26, 61, 124, 1),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          // 1. Video Player Section
          Container(
            height: 220,
            width: double.infinity,
            color: Colors.black,
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: const Color.fromRGBO(0, 191, 166, 1),
              onReady: () {
                _isPlayerReady = true;
              },
            ),
          ),

          // 2. Content Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(0, 191, 166, 0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'VIDEO LESSON',
                          style: TextStyle(
                            color: const Color.fromRGBO(0, 191, 166, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        lesson.duration ?? '10 min',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    lesson.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(26, 61, 124, 1),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Description / Transcript
                  const Text(
                    "Overview",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lesson.content ?? 
                    "In this lesson, we will explore the fundamental concepts necessary to master this skill. Pay close attention to the video demonstration. \n\nKey takeaways:\n• Understanding the basic tools\n• Safety precautions in the workspace\n• Step-by-step process execution\n• Common mistakes to avoid",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Resources / Actions
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(241, 242, 245, 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.download_rounded, color: Color.fromRGBO(26, 61, 124, 1)),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lesson Resources',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'PDF Guide (2.4 MB)',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: (){}, 
                          icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(0, -4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Logic for previous lesson
                  },
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lesson Marked as Complete!')),
                      );
                      // Logic to go to next lesson or finish
                      ref.read(navigationProvider.notifier).state = AppScreen.skillDetail;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 191, 166, 1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'COMPLETE LESSON',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
