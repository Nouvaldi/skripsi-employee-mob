import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/item_viewmodel.dart';
import 'cart_view.dart';
import '../models/size_enum.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Items'),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart_checkout_rounded),
            tooltip: 'Cart',
          ),
        ],
      ),
      body: ChangeNotifierProvider<ItemViewModel>(
        create: (_) => ItemViewModel()..fetchItems(),
        child: Consumer<ItemViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (query) {
                      viewModel.searchItems(query);
                    },
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await viewModel.fetchItems();
                    },
                    child: ListView.builder(
                      itemCount: viewModel.items.length,
                      itemBuilder: (context, index) {
                        final item = viewModel.items[index];
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 8),
                              Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.itemName,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                    ),
                                    item.status == 10
                                        ? Text(
                                            'Available',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                            ),
                                          )
                                        : const Text(
                                            'Out of Stock',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _showSizeDialog(context, item),
                                icon: const Icon(Icons.add),
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showSizeDialog(BuildContext context, Item item) {
    ItemSize selectedSize = ItemSize.S;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Size'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: ItemSize.values.map((size) {
                  return RadioListTile<ItemSize>(
                    title: Text(size.displayName),
                    value: size,
                    groupValue: selectedSize,
                    activeColor: Theme.of(context).colorScheme.surface,
                    onChanged: (value) {
                      setState(() {
                        selectedSize = value!;
                      });
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<CartViewModel>(context, listen: false)
                        .addItemToCart(
                      item,
                      selectedSize,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${item.itemName} added to cart!',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
