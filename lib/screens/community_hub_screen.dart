import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/providers/navigation_provider.dart';

class CommunityHubScreen extends ConsumerWidget {
  const CommunityHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 249, 251, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        // Go back to the Dashboard Home (Index 0)
                        ref.read(navigationProvider.notifier).state =
                            AppScreen.dashboard;
                        ref.read(dashboardIndexProvider.notifier).state = 0;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 191, 166, 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.groups,
                      color: Color.fromRGBO(0, 191, 166, 1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Community',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(26, 61, 124, 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Card 1: Connect and Learn
              _buildCommunityCard(
                title: 'Connect and Learn',
                subtitle: '12 Groups',
                tag: "Group Study",
                imageAsset: 'assets/images/group_study.png',
                buttonText: 'Explore Peer Community',
                onPressed: () {
                  // Navigate to Peer Community Screen
                  ref.read(navigationProvider.notifier).state =
                      AppScreen.peerCommunity;
                },
              ),

              const SizedBox(height: 24),

              // Card 2: Learn from Industry Experts
              _buildCommunityCard(
                title: 'Learn from Industry Experts',
                subtitle: '40 Mentors',
                tag: "Mentorship",
                imageAsset: 'assets/images/mentorship.png',
                buttonText: 'Find Mentors Close to you',
                onPressed: () {
                  // Navigate to Mentor List Screen
                  ref.read(navigationProvider.notifier).state =
                      AppScreen.mentorList;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommunityCard({
    required String title,
    required String subtitle,
    required String imageAsset,
    required String buttonText,
    required String tag,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[200], // Fallback color
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Center(
                      child: Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(26, 61, 124, 1),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.people_outline,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onPressed,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color.fromRGBO(0, 191, 166, 1),
                      side: const BorderSide(
                        color: Color.fromRGBO(0, 191, 166, 1),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
