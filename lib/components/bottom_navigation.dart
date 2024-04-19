import 'package:flutter/material.dart';

class MyBottomNavigation extends StatelessWidget {
  final int index;
  final void Function(int)? onTap;

  const MyBottomNavigation({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      elevation: 24,
      onTap: onTap,
      fixedColor: Theme.of(context).colorScheme.inversePrimary,
      unselectedItemColor: Theme.of(context).colorScheme.secondary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timer_rounded),
          label: 'Checkpoint'
        ),
      ],
    );
  }
}
