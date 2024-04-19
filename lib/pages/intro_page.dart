import 'package:employee_mobile/components/drawer.dart';
import 'package:employee_mobile/pages/checkpoint_page.dart';
import 'package:employee_mobile/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:employee_mobile/components/bottom_navigation.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int _currentIndex = 0;

  void _navigateBottomNav(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List _pages = [
    const HomePage(),
    const CheckPointPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Employee Mobile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      body: _pages[_currentIndex],
      bottomNavigationBar: MyBottomNavigation(
        index: _currentIndex,
        onTap: _navigateBottomNav,
      ),
    );
  }
}
