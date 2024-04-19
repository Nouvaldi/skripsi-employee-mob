import 'package:flutter/material.dart';
import '../components/button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              size: 72,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(height: 24),
            Text(
              'Employee Mobile',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Easily Manage Your Shop Transactions',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            const SizedBox(height: 24),
            MyButton(
              onTap: () => Navigator.pushNamed(context, '/intro_page'),
              child: Icon(
                Icons.arrow_forward,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
