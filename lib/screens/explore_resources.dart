// screens/explore_resources_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/providers/navigation_provider.dart';
import 'package:passright/providers/resource_provider.dart';
import 'package:passright/models/resource_model.dart';
import 'package:passright/providers/chat_provider.dart';
import 'package:url_launcher/url_launcher.dart'; // <-- STEP 2.1: ADD THIS IMPORT

class ExploreResourcesScreen extends ConsumerStatefulWidget {
  const ExploreResourcesScreen({super.key});

  @override
  ConsumerState<ExploreResourcesScreen> createState() =>
      _ExploreResourcesScreenState();
}

class _ExploreResourcesScreenState
    extends ConsumerState<ExploreResourcesScreen> {
  @override
  void initState() {
    super.initState();
    // Load resources when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadResources();
    });
  }

  void _loadResources() {
    final filters = ref.read(exploreResourcesProvider);
    ref
        .read(resourceProvider.notifier)
        .loadResources(subject: filters.subject, topic: filters.topic);
  }

  void _navigateToVideo(EducationalVideo video) {
    ref.read(selectedVideoProvider.notifier).state = video;
    ref.read(navigationProvider.notifier).state = AppScreen.videoPlayer;
  }

  void _navigateToAIWithContext(EducationalVideo? video) {
    final filters = ref.read(exploreResourcesProvider);
    ref.read(chatContextProvider.notifier).state = ChatContext(
      subject: filters.subject,
      topic: filters.topic,
      video: video,
    );
    ref.read(chatNavigationSourceProvider.notifier).state =
        ChatSource.resources;
    ref.read(navigationProvider.notifier).state = AppScreen.chat;
  }

  // <-- STEP 2.2: REPLACE THE OLD _openWebsite FUNCTION WITH THIS
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

  // NEW METHOD: Navigate to specific Khan Academy video
  void _navigateToKhanAcademyVideo() {
    print('NAVIGATING TO KHAN ACADEMY VIDEO!!!');

    final khanAcademyVideo = EducationalVideo(
      id: 'vDqOoI-4Z6M',
      title:
          'Introduction to algebra | Algebra for beginners | math | @Khan Academy',
      description:
          'This video gives an overview of Algebra and introduces the concepts of unknown values and variables.',
      channel: 'Khan Academy',
      thumbnailUrl: 'https://i.ytimg.com/vi/vDqOoI-4Z6M/mqdefault.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=vDqOoI-4Z6M',
      subject: 'Mathematics',
      topic: 'Introduction to Algebra',
      duration: const Duration(minutes: 10, seconds: 34),
    );

    ref.read(selectedVideoProvider.notifier).state = khanAcademyVideo;
    ref.read(navigationProvider.notifier).state = AppScreen.videoPlayer;
  }

  @override
  Widget build(BuildContext context) {
    final resourceState = ref.watch(resourceProvider);
    final filters = ref.watch(exploreResourcesProvider);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(252, 244, 242, 1),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    top: 95,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        style: OutlinedButton.styleFrom(
                          shape: const CircleBorder(),
                          side: BorderSide(
                            color: const Color.fromRGBO(0, 191, 166, 1),
                            width: 2.0,
                          ),
                          padding: const EdgeInsets.all(12),
                        ),
                        onPressed: () {
                          ref.read(navigationProvider.notifier).state =
                              AppScreen.coreSubjects;
                        },
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Explore Resources',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(26, 61, 124, 1),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${filters.subject} ${filters.topic != null ? '- ${filters.topic}' : ''}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 255, 255, 1),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                'assets/images/coresub.png',
                                scale: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),

                Container(
                  color: const Color.fromRGBO(241, 242, 245, 1),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 70,
                      left: 20,
                      right: 20,
                      top: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),

                        // YouTube Section
                        _buildYouTubeSection(resourceState),
                        const SizedBox(height: 30),

                        // Learning Platforms Section
                        _buildLearningPlatformsSection(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Positioned AI Button at the bottom
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              alignment: Alignment.center,
              color: const Color.fromRGBO(241, 242, 245, 1),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                width: 374,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(26, 61, 124, 1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _navigateToAIWithContext(null);
                  },
                  child: const Text(
                    'Dive Deeper with AI',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYouTubeSection(ResourceState resourceState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.play_circle_filled, color: Colors.red, size: 29),
            SizedBox(width: 2),
            Text(
              'YouTube',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),

        resourceState.isLoading
            ? _buildLoadingShimmer()
            : resourceState.videos.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: resourceState.videos.length,
                itemBuilder: (context, index) {
                  final video = resourceState.videos[index];
                  return _buildVideoCard(video);
                },
              ),
      ],
    );
  }

  Widget _buildVideoCard(EducationalVideo video) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300],
            image: video.thumbnailUrl.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(video.thumbnailUrl),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: video.thumbnailUrl.isEmpty
              ? const Icon(Icons.play_arrow, color: Colors.white, size: 30)
              : null,
        ),
        title: Text(
          video.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(video.channel, style: const TextStyle(color: Colors.grey)),
            Text(
              '${video.duration.inMinutes} min',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.chat_bubble_outline),
          onPressed: () {
            _navigateToAIWithContext(video);
          },
          tooltip: 'Ask AI about this video',
        ),
        onTap: () => _navigateToVideo(video),
      ),
    );
  }

  Widget _buildLearningPlatformsSection() {
    final filters = ref.watch(exploreResourcesProvider);
    final platforms = _getPlatformsForTopic(filters.subject, filters.topic);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Learning Platforms',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: platforms.length,
          itemBuilder: (context, index) {
            final platform = platforms[index];
            return _buildPlatformCard(platform);
          },
        ),
      ],
    );
  }

  Widget _buildPlatformCard(Resource platform) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          print('=== PLATFORM TAPPED: ${platform.title} ===');

          // Keep Khan Academy behavior as-is (navigates to specific video)
          if (platform.title == 'Khan Academy') {
            print('KHAN ACADEMY TAPPED - NAVIGATING TO VIDEO');
            _navigateToKhanAcademyVideo();
          } else {
            // NEW LOGIC: Navigate to specific URLs for other platforms
            String specificUrl;

            switch (platform.title) {
              case 'Coursera':
                specificUrl =
                    'https://www.coursera.org/specializations/algebra-elementary-to-advanced';
                break;
              case 'Udemy':
                // Add https:// to the provided URL
                specificUrl =
                    'https://www.udemy.com/course/algebraone/?srsltid=AfmBOopbfv_56vspzYJGotMWSBW5QgodADbFRh9ymwB5eJl8tP0a6O1d';
                break;
              case 'YouTube':
                specificUrl =
                    'https://youtube.com/playlist?list=PLgLRQbpBkgo_rT1_ypH_NuvW0y3LxCg3P&si=OSXf6wMgbe8Hkr6G';
                break;
              default:
                // Fallback to the URL defined in the resource data (e.g., for "Math is Fun")
                specificUrl = platform.url;
            }

            print('OPENING BROWSER WITH SPECIFIC URL: $specificUrl');
            // This now calls the REAL function
            _openWebsite(specificUrl);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (platform.title == 'Udemy')
                SizedBox(
                  width: 70,
                  height: 30,
                  child: platform.icon ?? const SizedBox(),
                )
              else if (platform.title == 'Coursera')
                Text(
                  platform.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                )
              else
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: platform.icon ?? const SizedBox(),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          platform.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 4),
              Text(
                platform.description ?? 'Learn more',
                style: TextStyle(color: Colors.grey[600], fontSize: 10),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: Container(width: 80, height: 60, color: Colors.grey[300]),
            title: Container(height: 16, color: Colors.grey[300]),
            subtitle: Container(height: 12, color: Colors.grey[200]),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No resources found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Try selecting a different subject or topic',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Platform methods

  List<Resource> _getPlatformsForTopic(String subject, String? topic) {
    if (subject == 'Mathematics') {
      switch (topic) {
        case 'Introduction to Algebra':
          return _getIntroToAlgebraPlatforms();
        case 'Advanced Algebra':
          return _getAdvancedAlgebraPlatforms();
        default:
          return _getDefaultPlatforms();
      }
    }
    return _getDefaultPlatforms();
  }

  List<Resource> _getIntroToAlgebraPlatforms() {
    return [
      Resource(
        title: 'Khan Academy',
        url:
            'https://www.khanacademy.org/math/algebra/x2f8bb11595b61c86:foundation-algebra',
        type: ResourceType.platform,
        description: 'Intro to Algebra course',
        icon: Image.asset('assets/images/khan.png'),
      ),
      Resource(
        title: 'Coursera',
        url: 'https://www.coursera.org/learn/algebra-primary',
        type: ResourceType.platform,
        description: 'Primary Algebra course',
      ),
      Resource(
        title: 'Math is Fun',
        url: 'https://www.mathsisfun.com/algebra/index.html',
        type: ResourceType.platform,
        description: 'Beginner algebra tutorials',
      ),
      Resource(
        title: 'YouTube',
        url:
            'https://www.youtube.com/results?search_query=introduction+to+algebra+for+beginners',
        type: ResourceType.platform,
        description: 'Algebra tutorials for beginners',
        icon: Image.asset('assets/images/youtube.png'),
      ),
    ];
  }

  List<Resource> _getAdvancedAlgebraPlatforms() {
    return [
      Resource(
        title: 'Khan Academy',
        url: 'https://www.khanacademy.org/math/algebra2',
        type: ResourceType.platform,
        description: 'Advanced Algebra course',
        icon: Image.asset('assets/images/khan.png'),
      ),
      Resource(
        title: 'Coursera',
        url: 'https://www.coursera.org/learn/advanced-algebra',
        type: ResourceType.platform,
        description: 'Advanced Algebra specialization',
      ),
      Resource(
        title: 'MIT OpenCourseWare',
        url: 'https://ocw.mit.edu/courses/mathematics/18-702-algebra-ii/',
        type: ResourceType.platform,
        description: 'College-level algebra',
      ),
      Resource(
        title: 'YouTube',
        url:
            'https://www.youtube.com/results?search_query=advanced+algebra+concepts',
        type: ResourceType.platform,
        description: 'Advanced algebra concepts',
        icon: Image.asset('assets/images/youtube.png'),
      ),
    ];
  }

  List<Resource> _getDefaultPlatforms() {
    return [
      Resource(
        title: 'Khan Academy',
        url: 'https://www.khanacademy.org',
        type: ResourceType.platform,
        description: 'Free online courses, lessons & practice',
        icon: Image.asset('assets/images/khan.png'),
      ),
      Resource(
        title: 'Coursera',
        url: 'httpsG://www.coursera.org',
        type: ResourceType.platform,
        description: 'Online courses from top universities',
      ),
      Resource(
        title: 'Udemy',
        url: 'https://www.udemy.com',
        type: ResourceType.platform,
        description: 'Learn to code interactively',
        icon: Image.asset('assets/images/udemyy.png'),
      ),
      Resource(
        title: 'YouTube',
        url: 'httpsG://www.youtube.com',
        type: ResourceType.platform,
        description: 'Educational channels & tutorials',
        icon: Image.asset('assets/images/youtube.png'),
      ),
    ];
  }
}
