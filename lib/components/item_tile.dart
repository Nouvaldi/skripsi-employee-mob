import 'package:employee_mobile/models/item_model.dart';
import 'package:flutter/material.dart';

class MyItemTile extends StatelessWidget {
  final Item item;

  const MyItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(color: Theme.of(context).colorScheme.secondary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Icon(Icons.favorite),
          Text(item.name),
          Text(item.price.toStringAsFixed(2)),
          Text(item.description),
        ],
      ),
    );
  }
}
