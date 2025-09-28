// dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/providers/navigation_provider.dart';
import 'package:passright/models/grid_item_data.dart';

class DashBoard extends ConsumerWidget {
  const DashBoard({super.key});

  void _handleGridItemTap(BuildContext context, String title, WidgetRef ref) {
    switch (title) {
      case 'Core Subjects':
        // Navigate to filter screen for core subjects
        ref.read(navigationProvider.notifier).state = AppScreen.filter;
        break;
      case 'Post Questions':
        // Navigate to filter screen for practice questions
        ref.read(navigationProvider.notifier).state = AppScreen.filter;
        break;
      case 'AI Tutor': // Add this case
        ref.read(navigationProvider.notifier).state = AppScreen.chat;
        break;
      case 'Vocational Training':
        // Show coming soon message or navigate to vocational screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vocational Training - Coming Soon!')),
        );
        break;
      case 'Language':
        // Show language selection or navigate to language screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Language Selection - Coming Soon!')),
        );
        break;
      default:
        // Default case for any other items
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title - Feature Coming Soon!')),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(dashboardIndexProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with time and notification
              Row(
                children: [
                  Text(
                    'Hello, Faith',
                    style: TextStyle(
                      color: Color.fromRGBO(26, 61, 124, 1),
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: CircleBorder(),
                      side: BorderSide(
                        color: Colors.teal,
                        width: 1.0,
                      ), // Reduced border width
                      padding: EdgeInsets.all(12),
                    ),
                    icon: Icon(Icons.notifications_none),
                  ),
                  SizedBox(width: 5),
                  IconButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: CircleBorder(),
                      side: BorderSide(color: Colors.teal, width: 1.0),
                      padding: EdgeInsets.all(12),
                    ),
                    icon: Icon(Icons.settings),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Search bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(241, 242, 245, 1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    // Add this line
                    color: Colors.grey[300]!, // Border color
                    width: 1.0, // Border width
                  ),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by subject, topic, or year',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.teal),
                    fillColor: Color.fromRGBO(241, 242, 245, 1),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Categories title
              Text(
                'Categories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Grid view
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: gridItems.length,
                  itemBuilder: (context, index) {
                    final item = gridItems[index];
                    return GestureDetector(
                      onTap: () =>
                          _handleGridItemTap(context, item['title'], ref),

                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          decoration: BoxDecoration(
                            color: item['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: item['color'].withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              item['image'],
                              SizedBox(height: 12),
                              Text(
                                item['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                item['subtitle'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // Add Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Set navigation source to dashboard before navigating
          ref.read(chatNavigationSourceProvider.notifier).state =
              ChatSource.dashboard;
          ref.read(navigationProvider.notifier).state = AppScreen.chat;
        },
        backgroundColor: const Color.fromRGBO(0, 191, 166, 1),
        child: Image.asset('assets/images/Group_9.png'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(dashboardIndexProvider.notifier).state = index;
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 5, 70, 122),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/home.png',
              color: currentIndex == 0
                  ? const Color.fromARGB(255, 5, 70, 122)
                  : Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/evaluation.png',
              color: currentIndex == 1
                  ? const Color.fromARGB(255, 5, 70, 122)
                  : Colors.grey,
            ),
            label: 'Practice',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/logo5.png',
              scale: 9,
              color: currentIndex == 2
                  ? const Color.fromARGB(255, 5, 70, 122)
                  : Colors.grey,
            ),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/Frame.png',
              scale: 1,
              color: currentIndex == 3
                  ? const Color.fromARGB(255, 5, 70, 122)
                  : Colors.grey,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
