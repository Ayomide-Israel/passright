import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/providers/navigation_provider.dart';
import 'package:passright/providers/vocational_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MentorProfileScreen extends ConsumerStatefulWidget {
  const MentorProfileScreen({super.key});

  @override
  ConsumerState<MentorProfileScreen> createState() =>
      _MentorProfileScreenState();
}

class _MentorProfileScreenState extends ConsumerState<MentorProfileScreen> {
  // State to track request status: 0 = Default, 1 = Waiting, 2 = Accepted
  int _requestStatus = 0;

  // ignore: unused_element
  void _launchDialer(String number) async {
    final Uri launchUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  void _handleRequest() {
    if (_requestStatus == 0) {
      // 1. Change to "Waiting"
      setState(() {
        _requestStatus = 1;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request Sent! Waiting for mentor approval...'),
          backgroundColor: Color.fromRGBO(0, 191, 166, 1),
        ),
      );

      // 2. Simulate Approval after 3 seconds (For demo purposes)
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _requestStatus = 2;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Request Accepted! You can now contact the mentor.',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mentor = ref.watch(selectedMentorProvider);

    if (mentor == null) {
      return const Scaffold(body: Center(child: Text("No mentor selected")));
    }

    // Determine Button Text & Color based on state
    String buttonText = 'Request Mentorship';
    Color buttonColor = const Color.fromRGBO(0, 191, 166, 1); // Teal
    Color textColor = Colors.white;

    if (_requestStatus == 1) {
      buttonText = 'Waiting for Approval...';
      buttonColor = Colors.grey;
    } else if (_requestStatus == 2) {
      buttonText = 'Request Accepted';
      buttonColor = Colors.green;
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(
        248,
        249,
        251,
        1,
      ), // Light background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color.fromRGBO(0, 191, 166, 1)),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              onPressed: () {
                // Return to Community Tab
                ref.read(dashboardIndexProvider.notifier).state = 2;
                ref.read(navigationProvider.notifier).state =
                    AppScreen.dashboard;
              },
            ),
          ),
        ),
        title: const Text(
          'Mentor Profile',
          style: TextStyle(
            color: Color.fromRGBO(26, 61, 124, 1),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          // 1. Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              100,
            ), // Bottom padding for floating button
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- Profile Header Card ---
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color.fromRGBO(0, 191, 166, 0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(0, 191, 166, 0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(mentor.imageUrl),
                          onBackgroundImageError: (_, __) {},
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name & Role
                      Text(
                        mentor.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(26, 61, 124, 1),
                        ),
                      ),
                      Text(
                        mentor.role,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Location & Directions Chips
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildChip(
                            Icons.location_on_outlined,
                            'Lokoja, Kogi',
                            false,
                          ),
                          const SizedBox(width: 12),
                          _buildChip(
                            Icons.directions_outlined,
                            'Directions',
                            true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Contact Info Section
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'CONTACT INFO',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildContactRow(
                        Icons.phone_outlined,
                        '+234 812 345 6789',
                      ),
                      const SizedBox(height: 16),
                      _buildContactRow(
                        Icons.email_outlined,
                        '${mentor.name.replaceAll(' ', '').toLowerCase()}@gmail.com',
                      ),
                      const SizedBox(height: 16),
                      _buildContactRow(
                        Icons.language,
                        'www.${mentor.name.split(' ')[0].toLowerCase()}-skills.com',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- Biography Section ---
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 191, 166, 1), // Teal Bar
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Biography',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(26, 61, 124, 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'With over 15 years in professional industries, I am passionate about mentoring the next generation of skilled workers. My training focuses on practical, hands-on experience and sustainable practices.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 30),

                // --- Skills Offered Section ---
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 191, 166, 1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Skills Offered',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(26, 61, 124, 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Skill Cards
                _buildSkillCard(
                  title: mentor.skillId == 'catering'
                      ? 'Catering'
                      : 'Advanced Techniques',
                  subtitle: 'Advanced culinary techniques',
                  imagePath: 'assets/images/vocational.png',
                ),
                const SizedBox(height: 12),
                _buildSkillCard(
                  title: mentor.skillId == 'catering'
                      ? 'Baking'
                      : 'Project Management',
                  subtitle: 'Incredible and tasty cakes',
                  imagePath: 'assets/images/vocational.png',
                ),

                const SizedBox(height: 30),

                // --- Stats Container ---
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(229, 231, 235, 0.5), // Grey bg
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('15+', 'YEARS EXP.'),
                      Container(width: 1, height: 40, color: Colors.grey[400]),
                      _buildStatItem('${mentor.rating}', 'RATING'),
                      Container(width: 1, height: 40, color: Colors.grey[400]),
                      _buildStatItem('${mentor.reviewCount}+', 'STUDENTS'),
                    ],
                  ),
                ),
                // Extra space for scrolling above the floating button
                const SizedBox(height: 20),
              ],
            ),
          ),

          // 2. Floating Action Button (Sticky Bottom)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.9),
                    Colors.white,
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _requestStatus == 0
                      ? _handleRequest
                      : null, // Disable if already requested
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: textColor,
                    elevation: 5,
                    shadowColor: buttonColor.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _requestStatus == 1
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          buttonText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildChip(IconData icon, String text, bool isHighlight) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isHighlight
            ? const Color.fromRGBO(0, 191, 166, 0.1)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isHighlight
                ? const Color.fromRGBO(0, 191, 166, 1)
                : Colors.grey[600],
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isHighlight
                  ? const Color.fromRGBO(0, 191, 166, 1)
                  : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 191, 166, 0.1), // Light teal circle
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color.fromRGBO(0, 191, 166, 1),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(26, 61, 124, 1),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillCard({
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) =>
                  Container(width: 60, height: 60, color: Colors.grey[200]),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color.fromRGBO(26, 61, 124, 1),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_outward,
              size: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(0, 191, 166, 1), // Teal
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
