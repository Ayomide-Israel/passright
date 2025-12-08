// video_player_screen.dart - UPDATED VERSION
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:passright/providers/navigation_provider.dart';
import 'package:passright/providers/resource_provider.dart';
import 'package:passright/providers/chat_provider.dart';
import 'package:url_launcher/url_launcher.dart'; // <-- 1. ADD THIS IMPORT

class VideoPlayerScreen extends ConsumerStatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  // ignore: unused_field
  bool _isPlayerReady = false;
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeVideoPlayer();
    });
  }

  void _initializeVideoPlayer() {
    final video = ref.read(selectedVideoProvider);

    if (video != null && !_isInitialized) {
      try {
        // The video.id field from the provider is the YouTube video ID
        String videoId = video.id; //

        _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            enableCaption: true,
            forceHD: true,
          ),
        )..addListener(_listener);

        setState(() {
          _isInitialized = true;
          _errorMessage = null;
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to initialize video: $e';
        });
      }
    }
  }

  void _listener() {
    if (_controller.value.hasError) {
      print('❌ YouTube player error: ${_controller.value.errorCode}');
      String errorMessage = 'Video playback error';

      // Provide more specific error messages
      switch (_controller.value.errorCode) {
        case 2:
          errorMessage = 'Invalid video ID';
          break;
        case 5:
          errorMessage = 'HTML5 player error';
          break;
        case 100:
          errorMessage = 'Video not found or removed';
          break;
        case 101:
        case 150:
          errorMessage = 'Video playback not allowed';
          break;
      }

      setState(() {
        _errorMessage = errorMessage;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-initialize if video changes and we're not already initialized
    if (!_isInitialized) {
      _initializeVideoPlayer();
    }
  }

  @override
  void deactivate() {
    // Add check to prevent error if controller isn't ready
    if (_isInitialized) {
      _controller.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    // Add check to prevent error if controller isn't ready
    if (_isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _navigateToAIWithContext() {
    final video = ref.read(selectedVideoProvider);
    if (video != null) {
      ref.read(chatContextProvider.notifier).state = ChatContext(
        subject: video.subject,
        topic: video.topic,
        video: video,
      ); //
      ref.read(chatNavigationSourceProvider.notifier).state =
          ChatSource.video; //
      ref.read(navigationProvider.notifier).state = AppScreen.chat; //
    }
  }

  void _retryInitialization() {
    setState(() {
      _isInitialized = false;
      _isPlayerReady = false;
      _errorMessage = null;
    });
    _initializeVideoPlayer();
  }

  // <-- 2. ADD THIS HELPER FUNCTION TO OPEN THE BROWSER
  void _openWebsite(String url) async {
    print('Attempting to open website: $url');
    final Uri uri = Uri.parse(url);
    try {
      // Launch the URL in an external browser
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('Could not launch $url');
        // Optional: Show an error message to the user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open the website.')),
          );
        }
      }
    } catch (e) {
      print('Error launching URL: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final video = ref.watch(selectedVideoProvider); //

    if (video == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Video Player'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              ref.read(navigationProvider.notifier).state =
                  AppScreen.exploreResources; //
            },
          ),
        ),
        body: const Center(child: Text('No video selected')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(video.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(navigationProvider.notifier).state =
                AppScreen.exploreResources; //
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: _navigateToAIWithContext,
            tooltip: 'Ask AI about this video',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _retryInitialization,
            tooltip: 'Retry video loading',
          ),
        ],
      ),
      body: !_isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Show error message if there's an error
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.red[50],
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: _retryInitialization,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),

                // YouTube Player
                YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.blueAccent,
                  progressColors: const ProgressBarColors(
                    playedColor: Colors.blue,
                    handleColor: Colors.blueAccent,
                  ),
                  thumbnail: video.thumbnailUrl.isNotEmpty
                      ? Image.network(video.thumbnailUrl)
                      : null,
                  bufferIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  onReady: () {
                    print('✅ YouTube player is ready');
                    setState(() {
                      _isPlayerReady = true;
                      _errorMessage = null;
                    });
                  },
                  onEnded: (data) {
                    print('🎬 Video ended');
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Channel: ${video.channel}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          Text(video.description),
                          const SizedBox(height: 20),

                          // <-- 3. ADD THE CONDITIONAL KHAN ACADEMY BUTTON HERE
                          // This button only appears if the video ID is the specific Khan Academy one
                          if (video.id == 'vDqOoI-4Z6M')
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Open the specific Khan Academy Algebra page
                                    _openWebsite(
                                      'https://www.khanacademy.org/math/algebra-home',
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.school_outlined,
                                  ), // Icon for learning
                                  label: const Text(
                                    'Dive Deeper with Khan Academy',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xFF142E2C,
                                    ), // Khan Academy dark green
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          // This is the existing "Dive Deeper with AI" button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _navigateToAIWithContext,
                              icon: const Icon(Icons.auto_awesome),
                              label: const Text('Dive Deeper with AI'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(
                                  26,
                                  61,
                                  124,
                                  1,
                                ),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
