// providers/resource_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/features/resources/models/resource_model.dart';

// Resource Filters Provider
class ResourceFilters {
  final String subject;
  final String? topic;

  const ResourceFilters({required this.subject, this.topic});
}

class ExploreResourcesNotifier extends StateNotifier<ResourceFilters> {
  ExploreResourcesNotifier()
    : super(const ResourceFilters(subject: 'Mathematics'));

  void setFilters({required String subject, String? topic}) {
    state = ResourceFilters(subject: subject, topic: topic);
  }
}

final exploreResourcesProvider =
    StateNotifierProvider<ExploreResourcesNotifier, ResourceFilters>(
      (ref) => ExploreResourcesNotifier(),
    );

// Resource Data Provider
final resourceProvider = StateNotifierProvider<ResourceNotifier, ResourceState>(
  (ref) => ResourceNotifier(),
);

final selectedVideoProvider = StateProvider<EducationalVideo?>((ref) => null);

class ResourceNotifier extends StateNotifier<ResourceState> {
  ResourceNotifier() : super(const ResourceState());

  Future<void> loadResources({required String subject, String? topic}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate API call - replace with actual YouTube API
      await Future.delayed(const Duration(seconds: 1));

      final videos = await _fetchYouTubeVideos(subject: subject, topic: topic);
      final resources = await _fetchOtherResources(
        subject: subject,
        topic: topic,
      );

      state = state.copyWith(
        videos: videos,
        otherResources: resources,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load resources: $e',
        isLoading: false,
      );
    }
  }

  Future<List<EducationalVideo>> _fetchYouTubeVideos({
    required String subject,
    String? topic,
  }) async {
    // Return specific videos based on subject and topic
    if (subject == 'Mathematics') {
      switch (topic) {
        case 'Introduction to Algebra':
          return _getIntroToAlgebraVideos();
        case 'Advanced Algebra':
          return _getAdvancedAlgebraVideos();
        default:
          // MODIFIED: This now returns the specific videos you requested
          return _getDefaultMathVideos(subject: subject, topic: topic);
      }
    }

    // Default for other subjects
    return _getDefaultVideos(subject: subject, topic: topic);
  }

  // Introduction to Algebra Videos
  List<EducationalVideo> _getIntroToAlgebraVideos() {
    return [
      EducationalVideo(
        id: 'NybHckSEQBI',
        title: 'Algebra Basics: What Is Algebra? - Math Antics',
        description:
            'This video gives an overview of Algebra and introduces the concepts of unknown values and variables.',
        channel: 'mathantics',
        thumbnailUrl: 'https://i.ytimg.com/vi/NybHckSEQBI/mqdefault.jpg',
        videoUrl: 'https://www.youtube.com/watch?v=NybHckSEQBI',
        subject: 'Mathematics',
        topic: 'Introduction to Algebra',
        duration: const Duration(minutes: 12, seconds: 7),
      ),

      EducationalVideo(
        id: 'KpC8MDe1H6g',
        title: 'Introduction to Algebra | Algebra for Beginners',
        description:
            'Basic algebra concepts for absolute beginners including variables and expressions.',
        channel: 'Professor Dave Explains',
        thumbnailUrl: 'https://i.ytimg.com/vi/KpC8MDe1H6g/mqdefault.jpg',
        videoUrl: 'https://www.youtube.com/watch?v=KpC8MDe1H6g',
        subject: 'Mathematics',
        topic: 'Introduction to Algebra',
        duration: const Duration(minutes: 15, seconds: 18),
      ),

      EducationalVideo(
        id: 'l3XzepN03KQ',
        title: 'Algebra for Beginners | Basics of Algebra',
        description:
            'Comprehensive introduction to algebra covering basic operations and simple equations.',
        channel: 'Geek\'s Lesson',
        thumbnailUrl: 'https://i.ytimg.com/vi/l3XzepN03KQ/mqdefault.jpg',
        videoUrl: 'https://www.youtube.com/watch?v=l3XzepN03KQ',
        subject: 'Mathematics',
        topic: 'Introduction to Algebra',
        duration: const Duration(minutes: 37, seconds: 9),
      ),
    ];
  }

  // Advanced Algebra Videos
  List<EducationalVideo> _getAdvancedAlgebraVideos() {
    return [
      EducationalVideo(
        id: 'U6F2vKNDK6E',
        title: 'Advanced Algebra Concepts and Examples',
        description:
            'Complex algebra problems including polynomial functions and advanced equations.',
        channel: 'Khan Academy',
        thumbnailUrl: 'https://i.ytimg.com/vi/U6F2vKNDK6E/mqdefault.jpg',
        videoUrl: 'https://www.youtube.com/watch?v=U6F2vKNDK6E',
        subject: 'Mathematics',
        topic: 'Advanced Algebra',
        duration: const Duration(minutes: 20, seconds: 45),
      ),
      EducationalVideo(
        id: 'VSKk6_O_6nI',
        title: 'Polynomials and Factoring - Advanced Algebra',
        description:
            'Deep dive into polynomial functions, factoring techniques, and complex algebraic structures.',
        channel: 'Organic Chemistry Tutor',
        thumbnailUrl: 'https://i.ytimg.com/vi/VSKk6_O_6nI/mqdefault.jpg',
        videoUrl: 'https://www.youtube.com/watch?v=VSKk6_O_6nI',
        subject: 'Mathematics',
        topic: 'Advanced Algebra',
        duration: const Duration(minutes: 25, seconds: 32),
      ),
      EducationalVideo(
        id: 'H2Tufqbl_mE',
        title: 'Advanced Algebra - Complete Course',
        description:
            'Complete advanced algebra course covering complex numbers, matrices, and advanced functions.',
        channel: 'Mario\'s Math Tutoring',
        thumbnailUrl: 'https://i.ytimg.com/vi/H2Tufqbl_mE/mqdefault.jpg',
        videoUrl: 'https://www.youtube.com/watch?v=H2Tufqbl_mE',
        subject: 'Mathematics',
        topic: 'Advanced Algebra',
        duration: const Duration(minutes: 45, seconds: 15),
      ),
    ];
  }

  // Default Math Videos for other math topics
  List<EducationalVideo> _getDefaultMathVideos({
    required String subject,
    String? topic,
  }) {
    return [
      // UPDATED: This video card now points to the specific "Intro to Algebra" video
      EducationalVideo(
        id: 'MHeirBPOI6w',
        title: 'Introduction to Algebra', // Updated title
        description:
            'This math video tutorial provides a basic introduction into algebra.',
        channel: 'The Organic Chemistry Tutor',
        thumbnailUrl: 'https://i.ytimg.com/vi/MHeirBPOI6w/mqdefault.jpg',
        videoUrl: 'https://www.youtube.com/watch?v=MHeirBPOI6w',
        subject: subject,
        topic: topic ?? 'Algebra Basics',
        duration: const Duration(minutes: 59, seconds: 7),
      ),
      // ADDED: This is the new "Advanced Algebra" video card
      EducationalVideo(
        id: 'i6sbjtJjJ-A',
        title: 'Advanced Algebra Introduction, Basic Review', // Shortened title
        description:
            'This algebra 2 introduction / basic review lesson video tutorial covers a wide range of topics.',
        channel: 'The Organic Chemistry Tutor',
        thumbnailUrl: 'https://i.ytimg.com/vi/i6sbjtJjJ-A/mqdefault.jpg',
        videoUrl: 'https://www.youtube.com/watch?v=i6sbjtJjJ-A',
        subject: subject,
        topic: topic ?? 'Advanced Algebra',
        duration: const Duration(hours: 3, minutes: 59, seconds: 44),
      ),
    ];
  }

  // Default Videos for non-math subjects
  List<EducationalVideo> _getDefaultVideos({
    required String subject,
    String? topic,
  }) {
    return [
      EducationalVideo(
        id: '2',
        title: 'Advanced $subject ${topic ?? ''} Concepts',
        description: 'Deep dive into advanced topics',
        channel: 'Math & Science Academy',
        thumbnailUrl: '',
        videoUrl: 'https://www.youtube.com/watch?v=example2',
        subject: subject,
        topic: topic,
        duration: const Duration(minutes: 20),
      ),
    ];
  }

  Future<List<Resource>> _fetchOtherResources({
    required String subject,
    String? topic,
  }) async {
    // You can add other resources here if needed
    return [];
  }
}
