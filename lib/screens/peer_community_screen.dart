import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/providers/navigation_provider.dart';

class PeerCommunityScreen extends ConsumerWidget {
  const PeerCommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 249, 251, 1),
      body: SafeArea(
        child: Column(
          children: [
            // 1. FIXED HEADER SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            ref.read(navigationProvider.notifier).state =
                                AppScreen.communityHub;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Study Groups',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(26, 61, 124, 1),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 191, 166, 1), // Teal
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 191, 166, 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Create Group - Coming Soon'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // 2. SCROLLABLE CONTENT SECTION
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // --- Suggested Peers Section ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Suggested Peers',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(26, 61, 124, 1),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'See All',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 191, 166, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Peers List
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildPeerItem(
                            'Israel A.',
                            'Python',
                            'https://pbs.twimg.com/profile_images/1978848591511797760/-kDy0YEK_400x400.jpg',
                            Colors.green,
                          ),
                          _buildPeerItem(
                            'Fatima',
                            'Baking',
                            'https://www.shutterstock.com/image-photo/young-african-muslim-girl-wearing-260nw-1195285726.jpg',
                            Colors.orange,
                          ),
                          _buildPeerItem(
                            'Sani Y.',
                            'Farming',
                            'https://pbs.twimg.com/profile_images/1641536797002833933/Xw_rnbts_400x400.jpg',
                            Colors.green,
                          ),
                          _buildPeerItem(
                            'Esther',
                            'Design',
                            'https://media.licdn.com/dms/image/v2/D5622AQExidzk4YZRxQ/feedshare-shrink_1280/B56Zr3eH01K8Aw-/0/1765088462514?e=1766620800&v=beta&t=Acs24CCkd_cAPQQ_byaVb0xv5Nq-XedZFWq2cNWaGQI',
                            Colors.grey,
                          ),
                          _buildPeerItem(
                            'John D.',
                            'Maths',
                            'https://img.freepik.com/free-photo/portrait-african-american-man_23-2148634067.jpg?semt=ais_se_enriched&w=740&q=80',
                            Colors.blue,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // --- Groups Near You Section ---
                    const Text(
                      'Groups Near You',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(26, 61, 124, 1),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Find a group...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Group Cards
                    _buildGroupCard(
                      ref, // passing ref for navigation later
                      title: '3MTT AI/ML Techies',
                      members: '9 members',
                      distance: '0.8 km',
                      tag: 'ICT',
                      imageAsset: 'assets/images/group_study.png',
                    ),
                    const SizedBox(height: 16),
                    _buildGroupCard(
                      ref,
                      title: 'Lagos Bakers Guild',
                      members: '24 members',
                      distance: '1.2 km',
                      tag: 'Catering',
                      imageAsset: 'assets/images/vocational.png',
                    ),
                    const SizedBox(height: 16),
                    _buildGroupCard(
                      ref,
                      title: 'JAMB Physics Squad',
                      members: '15 members',
                      distance: '0.5 km',
                      tag: 'Academic',
                      imageAsset: 'assets/images/coresub.png',
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeerItem(
    String name,
    String skill,
    String imageUrl,
    Color statusColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(imageUrl),
                onBackgroundImageError: (_, __) {},
                backgroundColor: Colors.grey[200],
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color.fromRGBO(26, 61, 124, 1),
            ),
          ),
          Text(skill, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildGroupCard(
    WidgetRef ref, {
    required String title,
    required String members,
    required String distance,
    required String tag,
    required String imageAsset,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Tag
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Center(
                      child: Icon(Icons.group, color: Colors.grey),
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
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.people_outline,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      members,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      distance,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(navigationProvider.notifier).state =
                          AppScreen.groupDetail;
                    },
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
                    child: const Text(
                      'Join Group',
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
