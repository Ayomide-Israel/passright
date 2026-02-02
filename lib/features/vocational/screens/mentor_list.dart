import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/features/vocational/models/vocational_models.dart';
import 'package:passright/features/vocational/providers/vocational_provider.dart';
import 'package:passright/core/providers/navigation_provider.dart';

class MentorScreen extends ConsumerStatefulWidget {
  const MentorScreen({super.key});

  @override
  ConsumerState<MentorScreen> createState() => _MentorScreenState();
}

class _MentorScreenState extends ConsumerState<MentorScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = [
    'All',
    'Catering',
    'Tailoring',
    'ICT',
    'Agriculture',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleBack(WidgetRef ref) {
    // Logic to determine where to go back to based on the current context
    final currentTab = ref.read(dashboardIndexProvider);

    if (currentTab == 2) {
      // If we are on the Community Tab, go back to the Community Hub
      ref.read(navigationProvider.notifier).state = AppScreen.communityHub;
    } else {
      // If we are NOT on the Community Tab (e.g. came from Skill Detail), go back to Skill Detail
      ref.read(navigationProvider.notifier).state = AppScreen.skillDetail;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Get mentors from provider
    final allMentors = ref.watch(mentorListProvider);

    // 2. Filter mentors logic
    List<Mentor> filteredMentors = allMentors.where((mentor) {
      // Category Filter
      final matchesCategory =
          selectedCategory == 'All' ||
          mentor.skillId.toLowerCase() == selectedCategory.toLowerCase() ||
          (selectedCategory == 'Agriculture' && mentor.skillId == 'agric');

      // Search Filter
      final matchesSearch =
          mentor.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          mentor.role.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();

    // 3. Sort by Distance (Proximity Logic)
    filteredMentors.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 249, 251, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // --- Header ---
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color.fromRGBO(0, 191, 166, 1)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => _handleBack(ref),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Mentors',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color.fromRGBO(26, 61, 124, 1),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- Search Bar ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => searchQuery = val),
                  decoration: const InputDecoration(
                    hintText: 'Search for mentors, skills, or roles...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- Categories Header ---
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(26, 61, 124, 1),
                ),
              ),
              const SizedBox(height: 12),

              // --- Category Chips ---
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: Row(
                  children: categories.map((category) {
                    final isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => selectedCategory = category),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color.fromRGBO(0, 191, 166, 1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.grey.shade300,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color.fromRGBO(
                                        0,
                                        191,
                                        166,
                                        0.4,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // --- Available Mentors Header ---
              Row(
                children: [
                  const Text(
                    'Available Mentors',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(26, 61, 124, 1),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${filteredMentors.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // --- Mentors List ---
              Expanded(
                child: filteredMentors.isEmpty
                    ? Center(
                        child: Text(
                          "No mentors found nearby.",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredMentors.length,
                        padding: const EdgeInsets.only(bottom: 20),
                        itemBuilder: (context, index) {
                          final mentor = filteredMentors[index];
                          return _buildMentorCard(context, ref, mentor);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMentorCard(BuildContext context, WidgetRef ref, Mentor mentor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          // 1. Avatar Stack with Online Dot
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(mentor.imageUrl),
                    fit: BoxFit.cover,
                    onError: (_, __) {},
                  ),
                  color: Colors.grey[200],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 191, 166, 1), // Teal
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // 2. Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mentor.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(26, 61, 124, 1),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  mentor.role,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                // Proximity Badge
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: Color.fromRGBO(0, 191, 166, 1),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${mentor.distanceKm} km away',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(0, 191, 166, 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 3. Connect Button
          SizedBox(
            height: 32,
            child: ElevatedButton(
              onPressed: () {
                // Set the selected mentor
                ref.read(selectedMentorProvider.notifier).state = mentor;
                // Navigate to the profile
                ref.read(navigationProvider.notifier).state =
                    AppScreen.mentorProfile;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(
                  224,
                  247,
                  244,
                  1,
                ), // Light Teal bg
                foregroundColor: const Color.fromRGBO(
                  0,
                  191,
                  166,
                  1,
                ), // Teal text
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: const Text(
                'Connect',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
