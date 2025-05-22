import 'package:flutter/material.dart';
import 'package:flavorith/presentation/widgets/bottom_navigation.dart';
import 'package:flavorith/presentation/pages/profile/profile_page.dart';
import 'package:flavorith/presentation/pages/search/search_page.dart';
import 'package:flavorith/presentation/pages/add_recipe/add_recipe_page.dart';
import 'package:flavorith/presentation/pages/favorites/favorites_page.dart';
import 'package:flavorith/presentation/pages/home/home_content_page.dart';
// Import other pages for navigation here

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContentPage(),
    const SearchPage(),
    const AddRecipePage(),
    const FavoritesPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
} 