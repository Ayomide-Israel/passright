import 'package:flutter/material.dart';

class Lesson {
  final String title;
  final String? duration;
  final String? content;
  final bool isExpandable;

  const Lesson({
    required this.title,
    this.duration,
    this.content,
    this.isExpandable = false,
  });
}

class VocationalSkill {
  final String id;
  final String title;
  final String description;
  final String gridImagePath;
  final String detailImagePath;
  final Color color;
  final String introductionTitle;
  final String introductionDescription;
  final List<Lesson> lessons;

  const VocationalSkill({
    required this.id,
    required this.title,
    required this.description,
    required this.gridImagePath,
    required this.detailImagePath,
    required this.color,
    required this.introductionTitle,
    required this.introductionDescription,
    required this.lessons,
  });
}

class Mentor {
  final String id;
  final String name;
  final String role; // Changed from businessName to match design better, but can map to it
  final String skillId;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final String imageUrl;
  final bool isVerified;
  final List<String> tags;

  const Mentor({
    required this.id,
    required this.name,
    required this.role,
    required this.skillId,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.imageUrl,
    this.isVerified = false,
    required this.tags,
  });
}

// --- MOCK DATA ---

final List<VocationalSkill> vocationalSkills = [
  VocationalSkill(
    id: 'catering',
    title: 'Catering',
    description: 'Culinary arts, baking, and food management.',
    gridImagePath: 'assets/images/catering.png', 
    detailImagePath: 'assets/images/catering_detail.png',
    color: Colors.orange,
    introductionTitle: 'Master the Art of Cooking',
    introductionDescription: 'Learn how to prepare local and continental dishes, manage a kitchen, and start your own food business.',
    lessons: [
      Lesson(title: 'Kitchen Hygiene & Safety', duration: '15 min'),
      Lesson(title: 'Knife Skills 101', duration: '20 min'),
      Lesson(title: 'Nigerian Jollof Mastery', duration: '45 min'),
    ],
  ),
  VocationalSkill(
    id: 'tailoring',
    title: 'Tailoring',
    description: 'Fashion design, cutting, and sewing.',
    gridImagePath: 'assets/images/tailoring.png',
    detailImagePath: 'assets/images/tailoring_detail.png',
    color: Colors.purple,
    introductionTitle: 'Fashion & Design',
    introductionDescription: 'Understand fabrics, measurements, and how to sew perfectly fitted clothes.',
    lessons: [
      Lesson(title: 'Understanding Fabrics', duration: '10 min'),
      Lesson(title: 'Taking Measurements', duration: '25 min'),
      Lesson(title: 'Using the Sewing Machine', duration: '30 min'),
    ],
  ),
  VocationalSkill(
    id: 'ict',
    title: 'ICT & Coding',
    description: 'Web dev, graphic design, and computer literacy.',
    gridImagePath: 'assets/images/ict.png',
    detailImagePath: 'assets/images/ict_detail.png',
    color: Colors.blue,
    introductionTitle: 'Digital Skills',
    introductionDescription: 'Learn to code, design graphics, and navigate the digital world.',
    lessons: [
      Lesson(title: 'Intro to Computers', duration: '15 min'),
      Lesson(title: 'Graphic Design Basics', duration: '40 min'),
      Lesson(title: 'Web Development 101', duration: '1 hr'),
    ],
  ),
  VocationalSkill(
    id: 'agric',
    title: 'Agriculture',
    description: 'Farming, poultry, and fishery.',
    gridImagePath: 'assets/images/agric.png',
    detailImagePath: 'assets/images/agriculture_detail.png',
    color: Colors.green,
    introductionTitle: 'Modern Farming',
    introductionDescription: 'Explore sustainable farming, crop rotation, and agribusiness.',
    lessons: [
      Lesson(title: 'Soil Types & Preparation', duration: '20 min'),
      Lesson(title: 'Poultry Management', duration: '35 min'),
    ],
  ),
];

final List<Mentor> mockMentors = [
  Mentor(
    id: 'm1',
    name: 'Grace Ola',
    role: 'Catering Expert',
    skillId: 'catering',
    rating: 4.8,
    reviewCount: 124,
    distanceKm: 0.5,
    imageUrl: 'https://i.pravatar.cc/150?u=m1',
    isVerified: true,
    tags: ['Baking', 'Cooking'],
  ),
  Mentor(
    id: 'm2',
    name: 'Ben Igwe',
    role: 'ICT Specialist',
    skillId: 'ict',
    rating: 4.9,
    reviewCount: 56,
    distanceKm: 1.2,
    imageUrl: 'https://i.pravatar.cc/150?u=m2',
    isVerified: true,
    tags: ['Web Dev', 'Python'],
  ),
  Mentor(
    id: 'm3',
    name: 'Aisha Abu',
    role: 'Master Tailor',
    skillId: 'tailoring',
    rating: 4.5,
    reviewCount: 89,
    distanceKm: 2.5,
    imageUrl: 'https://i.pravatar.cc/150?u=m3',
    isVerified: false,
    tags: ['Unisex', 'Design'],
  ),
  Mentor(
    id: 'm4',
    name: 'David Obi',
    role: 'Agriculture Innovator',
    skillId: 'agric',
    rating: 4.7,
    reviewCount: 42,
    distanceKm: 3.1,
    imageUrl: 'https://i.pravatar.cc/150?u=m4',
    isVerified: true,
    tags: ['Farming', 'Crops'],
  ),
  Mentor(
    id: 'm5',
    name: 'Samuel Kalu',
    role: 'Frontend Dev',
    skillId: 'ict',
    rating: 4.6,
    reviewCount: 20,
    distanceKm: 0.8, 
    imageUrl: 'https://i.pravatar.cc/150?u=m5',
    isVerified: true,
    tags: ['React', 'Flutter'],
  ),
];