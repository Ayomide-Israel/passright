import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passright/core/providers/navigation_provider.dart';
import 'package:passright/features/dashboard/models/grid_item_data.dart';
import 'package:passright/features/community/providers/chat_provider.dart';
import 'package:passright/features/academic/screens/filter.dart';
import 'package:passright/features/community/screens/community_hub_screen.dart'; // Changed from CommunityConnectScreen

class DashBoard extends ConsumerWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(dashboardIndexProvider);

    Widget buildBody() {
      switch (currentIndex) {
        case 0:
          return const _HomeContent();
        case 1:
          return const FiltersScreen();
        case 2:
          return const CommunityHubScreen(); // Shows Hub first
        case 3:
          return const Center(child: Text("Profile - Coming Soon"));
        default:
          return const _HomeContent();
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: buildBody(),
      
      floatingActionButton: currentIndex == 0 ? FloatingActionButton(
        onPressed: () {
          ref.read(chatContextProvider.notifier).state = null;
          ref.read(chatNavigationSourceProvider.notifier).state = ChatSource.dashboard;
          ref.read(navigationProvider.notifier).state = AppScreen.chat;
        },
        backgroundColor: const Color.fromRGBO(0, 191, 166, 1),
        shape: const CircleBorder(),
        child: Image.asset('assets/images/Group_9.png'), 
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(dashboardIndexProvider.notifier).state = index;
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromRGBO(5, 70, 122, 1),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        elevation: 10,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Image.asset('assets/images/home.png', 
                height: 24,
                color: currentIndex == 0 ? const Color.fromRGBO(5, 70, 122, 1) : Colors.grey),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Image.asset('assets/images/evaluation.png', 
                height: 24,
                color: currentIndex == 1 ? const Color.fromRGBO(5, 70, 122, 1) : Colors.grey),
            ),
            label: 'Practice',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Image.asset('assets/images/logo5.png', 
                height: 24,
                color: currentIndex == 2 ? const Color.fromRGBO(5, 70, 122, 1) : Colors.grey),
            ),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Image.asset('assets/images/Frame.png', 
                height: 24,
                color: currentIndex == 3 ? const Color.fromRGBO(5, 70, 122, 1) : Colors.grey),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Hello, Faith', 
                  style: TextStyle(
                    color: Color.fromRGBO(26, 61, 124, 1), 
                    fontWeight: FontWeight.w900, 
                    fontSize: 24
                  )
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: IconButton(
                    onPressed: (){}, 
                    icon: const Icon(Icons.notifications_none, color: Color.fromRGBO(5, 70, 122, 1)),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: IconButton(
                    onPressed: (){}, 
                    icon: const Icon(Icons.settings_outlined, color: Color.fromRGBO(5, 70, 122, 1)),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(248, 249, 251, 1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search by subject, topic, or year',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Color.fromRGBO(0, 191, 166, 1)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Categories', 
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(26, 61, 124, 1) 
              )
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  crossAxisSpacing: 16, 
                  mainAxisSpacing: 16, 
                  childAspectRatio: 0.85 
                ),
                itemCount: gridItems.length,
                itemBuilder: (context, index) {
                  final item = gridItems[index];
                  return GestureDetector(
                    onTap: () => _handleGridItemTap(context, item['title'], ref),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: (item['color'] as Color).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: SizedBox(
                              width: 32,
                              height: 32,
                              child: item['image'], 
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            item['title'], 
                            style: const TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 16,
                              color: Color.fromRGBO(26, 61, 124, 1)
                            ), 
                            textAlign: TextAlign.center
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              item['subtitle'], 
                              style: TextStyle(
                                fontSize: 12, 
                                color: Colors.grey[500],
                                height: 1.2
                              ), 
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
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
