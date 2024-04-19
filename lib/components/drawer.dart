import 'package:employee_mobile/components/list_tile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          DrawerHeader(
            child: Icon(
              Icons.shopping_bag,
              size: 72,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          const SizedBox(height: 24),
          MyListTile(
            text: 'Home',
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),
          MyListTile(
            text: 'Settings',
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings_page');
            },
          ),
          const Spacer(),
          MyListTile(
            text: 'Log out',
            icon: Icons.logout,
            onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/login_page', (route) => false),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
