import 'package:employee_mobile/components/item_tile.dart';
import 'package:employee_mobile/models/shop_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemListPage extends StatelessWidget {
  const ItemListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.watch<Shop>().shop;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item List'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return MyItemTile(item: item);
        },
      ),
    );
  }
}
