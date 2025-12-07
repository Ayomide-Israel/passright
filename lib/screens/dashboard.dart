import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/providers/navigation_provider.dart';
import 'package:passright/models/grid_item_data.dart';
import 'package:passright/providers/chat_provider.dart';
import 'package:passright/screens/filter.dart';
import 'package:passright/screens/community_connect_screen.dart';

class DashBoard extends ConsumerWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Get the current tab index from the provider
    final currentIndex = ref.watch(dashboardIndexProvider);

    // 2. Define the bodies for each tab
    Widget buildBody() {
      switch (currentIndex) {
        case 0:
          return const _HomeContent(); // The main dashboard grid
        case 1:
          return const FiltersScreen(); // "Practice" Tab opens filters
        case 2:
          return const CommunityConnectScreen(); // "Community" Tab opens radar
        case 3:
          return const Center(child: Text("Profile - Coming Soon"));
        default:
          return const _HomeContent();
      }
    }

    return Scaffold(
      // 3. Show the correct body based on the tab
      body: buildBody(),
      
      // Floating Action Button (Only on Home)
      floatingActionButton: currentIndex == 0 ? FloatingActionButton(
        onPressed: () {
          ref.read(chatContextProvider.notifier).state = null;
          ref.read(chatNavigationSourceProvider.notifier).state = ChatSource.dashboard;
          ref.read(navigationProvider.notifier).state = AppScreen.chat;
        },
        backgroundColor: const Color.fromRGBO(0, 191, 166, 1),
        child: Image.asset('assets/images/Group_9.png'),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // 4. Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // Update the provider to switch tabs
          ref.read(dashboardIndexProvider.notifier).state = index;
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 5, 70, 122),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/home.png', color: currentIndex == 0 ? const Color.fromARGB(255, 5, 70, 122) : Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/evaluation.png', color: currentIndex == 1 ? const Color.fromARGB(255, 5, 70, 122) : Colors.grey),
            label: 'Practice',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/logo5.png', scale: 9, color: currentIndex == 2 ? const Color.fromARGB(255, 5, 70, 122) : Colors.grey),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/Frame.png', scale: 1, color: currentIndex == 3 ? const Color.fromARGB(255, 5, 70, 122) : Colors.grey),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Extracted Home Content Widget to keep code clean
class _HomeContent extends ConsumerWidget {
  const _HomeContent();

  void _handleGridItemTap(BuildContext context, String title, WidgetRef ref) {
    switch (title) {
      case 'Core Subjects':
        ref.read(navigationProvider.notifier).state = AppScreen.coreSubjects;
        break;
      case 'Past Questions':
        ref.read(navigationProvider.notifier).state = AppScreen.filter;
        break;
      case 'Vocational Training':
        ref.read(navigationProvider.notifier).state = AppScreen.vocationalTraining;
        break;
      case 'Language':
        ref.read(navigationProvider.notifier).state = AppScreen.language;
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title - Coming Soon!')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Text('Hello, Faith', style: TextStyle(color: Color.fromRGBO(26, 61, 124, 1), fontWeight: FontWeight.w900, fontSize: 24)),
                const Spacer(),
                IconButton(onPressed: (){}, icon: const Icon(Icons.notifications_none, color: Colors.teal)),
                IconButton(onPressed: (){}, icon: const Icon(Icons.settings, color: Colors.teal)),
              ],
            ),
            const SizedBox(height: 20),
            
            // Search
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: const Color.fromRGBO(241, 242, 245, 1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[300]!)),
              child: const TextField(decoration: InputDecoration(hintText: 'Search by subject, topic, or year', border: InputBorder.none, icon: Icon(Icons.search, color: Colors.teal))),
            ),
            const SizedBox(height: 30),
            
            // Grid
            const Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.9),
                itemCount: gridItems.length,
                itemBuilder: (context, index) {
                  final item = gridItems[index];
                  return GestureDetector(
                    onTap: () => _handleGridItemTap(context, item['title'], ref),
                    child: Container(
                      decoration: BoxDecoration(color: item['color'].withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: item['color'].withOpacity(0.3))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          item['image'],
                          const SizedBox(height: 12),
                          Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
                          const SizedBox(height: 8),
                          Text(item['subtitle'], style: TextStyle(fontSize: 12, color: Colors.grey[600]), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}