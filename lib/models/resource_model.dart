import 'package:flutter/material.dart';
// models/resource_model.dart

// Add this enum at the top of the file
enum ResourceType { website, video, document, practice, platform }

class EducationalVideo {
  final String id;
  final String title;
  final String description;
  final String channel;
  final String thumbnailUrl;
  final String videoUrl;
  final String subject;
  final String? topic;
  final Duration duration;

  const EducationalVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.channel,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.subject,
    this.topic,
    required this.duration,
  });
}

class Resource {
  final String title;
  final String url;
  final ResourceType type;
  final String? subject;
  final String? topic;
  final String? description;
  final Image? icon;
  final Color color;

  const Resource({
    required this.title,
    required this.url,
    required this.type,
    this.subject,
    this.topic,
    this.description,
    this.icon,
    this.color = Colors.blue,
  });
}

class ResourceState {
  final List<EducationalVideo> videos;
  final List<Resource> otherResources;
  final bool isLoading;
  final String? error;

  const ResourceState({
    this.videos = const [],
    this.otherResources = const [],
    this.isLoading = false,
    this.error,
  });

  ResourceState copyWith({
    List<EducationalVideo>? videos,
    List<Resource>? otherResources,
    bool? isLoading,
    String? error,
  }) {
    return ResourceState(
      videos: videos ?? this.videos,
      otherResources: otherResources ?? this.otherResources,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
