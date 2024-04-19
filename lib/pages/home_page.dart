import 'package:employee_mobile/components/button.dart';
import 'package:employee_mobile/components/custom_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              MyCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Welcome back,',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    Text(
                      'A Very Very Long Name',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              MyCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEW',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Announcement',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    Text(
                      '18 April 2024',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Pengumuman hari libur pada tanggal 8 April 2024 hingga 12 April 2024. Hari kerja seperti biasa dimulai pada tanggal 15 April 2024.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              MyButton(
                onTap: () => Navigator.pushNamed(context, '/item_list_page'),
                child: Icon(
                  Icons.add_shopping_cart_rounded,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
