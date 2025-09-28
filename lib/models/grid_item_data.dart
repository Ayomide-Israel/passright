import 'package:flutter/material.dart';

final List<Map<String, dynamic>> gridItems = [
  {
    'title': 'Core Subjects',
    'subtitle': 'English, Maths, Chemistry',
    'image': Image.asset('assets/images/coresub.png'),
    'color': Colors.blue,
  },
  {
    'title': 'Post Questions',
    'subtitle': 'CBT with Timer',
    'image': Image.asset(
      'assets/images/logo3.png',
      scale: 3,
      color: Colors.teal,
    ),
    'color': Colors.green,
  },

  {
    'title': 'Vocational Training',
    'subtitle': 'Learn a skill',
    'image': Image.asset('assets/images/logo6.png', scale: 3),
    'color': Colors.orange,
  },
  {
    'title': 'Language',
    'subtitle': 'Switch Language',
    'image': Image.asset('assets/images/logo4.png', scale: 3),
    'color': Colors.purple,
  },
];
