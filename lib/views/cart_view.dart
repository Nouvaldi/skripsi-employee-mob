import 'package:employee_mobile/components/my_elevated_button.dart';
import 'package:employee_mobile/models/size_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Cart'),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final isConfirmed =
                  await _showClearCartConfirmationDialog(context);
              if (isConfirmed) {
                Provider.of<CartViewModel>(context, listen: false).clearCart();
              }
            },
            tooltip: 'Clear Cart',
          ),
        ],
      ),
      body: Consumer<CartViewModel>(
        builder: (context, cartViewModel, child) {
          final totalPrice = NumberFormat.currency(locale: 'id', symbol: 'Rp.')
              .format(cartViewModel.totalPrice);

          if (cartViewModel.cartItems.isEmpty) {
            return Center(
              child: Text(
                'Cart is Empty.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartViewModel.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartViewModel.cartItems[index];
                    final basePrice =
                        NumberFormat.currency(locale: 'id', symbol: 'Rp.')
                            .format(cartItem.item.price);
                    final totalAmount =
                        NumberFormat.currency(locale: 'id', symbol: 'Rp.')
                            .format(cartItem.itemPrice * cartItem.quantity);

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
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // ClipRRect(
                              //   borderRadius: BorderRadius.circular(8),
                              //   child: Container(
                              //     padding: const EdgeInsets.all(32),
                              //     color: Colors.blue.shade400,
                              //   ),
                              // ),
                              // const SizedBox(width: 8),
                              Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${cartItem.item.itemName} ',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                    ),
                                    Text(
                                      '(${cartItem.size.displayName})',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  cartViewModel.updateQuantity(
                                      cartItem, cartItem.quantity - 1);
                                },
                              ),
                              Text(
                                cartItem.quantity.toString(),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  cartViewModel.updateQuantity(
                                      cartItem, cartItem.quantity + 1);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Flex(
                            direction: Axis.horizontal,
                            children: [
                              Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: Text(
                                  'Base Price: ',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                ),
                              ),
                              Text(
                                basePrice,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Price Input Field
                          Flex(
                            direction: Axis.horizontal,
                            children: [
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Text(
                                  'Price: ',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                ),
                              ),
                              Text(
                                'Rp. ',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    final price = double.tryParse(value) ?? 0.0;
                                    cartViewModel.updateItemPrice(
                                        cartItem, price);
                                  },
                                  decoration: InputDecoration(
                                    hintText: cartItem.itemPrice.toString(),
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Divider(),
                          // Display Total Price
                          Flex(
                            direction: Axis.horizontal,
                            children: [
                              Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: Text(
                                  'Total Amount: ',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                ),
                              ),
                              Text(
                                totalAmount,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Total Price: $totalPrice',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    MyElevatedButton(
                      onPressed: () async {
                        final isConfirmed =
                            await _showConfirmationDialog(context);
                        if (isConfirmed) {
                          await cartViewModel.submitCart(context);
                        }
                      },
                      icon: const Icon(Icons.shopping_cart_checkout),
                      label: const Text('Submit Transaction'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirm Transaction'),
              content: const Text(
                  'Are you sure you want to submit the transaction? \n\n(Data CAN NOT be changed. Please make sure the data is correct.)'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<bool> _showClearCartConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Clear Cart'),
              content: const Text('Are you sure you want to clear the cart?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    'Clear',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
