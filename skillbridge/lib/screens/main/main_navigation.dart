import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'post_skill_screen.dart';
import 'messages_screen.dart';
import 'profile_screen.dart';

/// Hosts the five primary tabs of the app behind a [BottomNavigationBar],
/// demonstrating an `IndexedStack` so each tab keeps its own scroll
/// position / state when switching back and forth.
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    SearchScreen(),
    PostSkillScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  void _onTap(int index) {
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_rounded, size: 30),
            label: 'Post',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
