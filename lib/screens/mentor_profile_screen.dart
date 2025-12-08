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

  void _launchDialer(String number) async {
    final Uri launchUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  // CORRECTED: Launch Google Maps Directions
  // Origin: Current Location (Automatic)
  // Destination: Mentor's Address
  Future<void> _launchMaps(String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    // Use the official Universal Cross-Platform Google Maps URL
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$encodedAddress',
    );

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch maps application.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error launching maps: $e')));
      }
    }
  }

  void _handleRequest() {
    if (_requestStatus == 0) {
      setState(() {
        _requestStatus = 1;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request Sent! Waiting for mentor approval...'),
          backgroundColor: Color.fromRGBO(0, 191, 166, 1),
        ),
      );

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

    String buttonText = 'Request Mentorship';
    Color buttonColor = const Color.fromRGBO(0, 191, 166, 1);
    Color textColor = Colors.white;

    if (_requestStatus == 1) {
      buttonText = 'Waiting for Approval...';
      buttonColor = Colors.grey;
    } else if (_requestStatus == 2) {
      buttonText = 'Request Accepted';
      buttonColor = Colors.green;
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 249, 251, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color.fromRGBO(0, 191, 166, 1)),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              onPressed: () {
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
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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

                      // --- FIXED ROW FOR CHIPS ---
                      // Used Flexible on the location chip to prevent overflow
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: _buildChip(
                              icon: Icons.location_on_outlined,
                              text: mentor.location,
                              isHighlight: false,
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildChip(
                            icon: Icons.directions_outlined,
                            text: 'Directions',
                            isHighlight: true,
                            onTap: () {
                              _launchMaps(mentor.location);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

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
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(229, 231, 235, 0.5),
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
                const SizedBox(height: 20),
              ],
            ),
          ),
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
                  onPressed: _requestStatus == 0 ? _handleRequest : null,
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

  // UPDATED: Fixed overflow by removing Fixed Width and using Flexible inside
  Widget _buildChip({
    required IconData icon,
    required String text,
    required bool isHighlight,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isHighlight
              ? const Color.fromRGBO(0, 191, 166, 0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: isHighlight
              ? Border.all(color: const Color.fromRGBO(0, 191, 166, 0.5))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // shrink to fit
          children: [
            Icon(
              icon,
              size: 16,
              color: isHighlight
                  ? const Color.fromRGBO(0, 191, 166, 1)
                  : Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isHighlight
                      ? const Color.fromRGBO(0, 191, 166, 1)
                      : Colors.grey[700],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
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
            color: const Color.fromRGBO(0, 191, 166, 0.1),
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
            color: Color.fromRGBO(0, 191, 166, 1),
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
