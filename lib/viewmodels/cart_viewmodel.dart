import 'dart:convert';
import 'package:employee_mobile/config.dart';
import 'package:employee_mobile/models/size_enum.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/item.dart';
import 'package:http/http.dart' as http;

class CartViewModel with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addItemToCart(Item item, ItemSize size) {
    _cartItems.add(CartItem(item: item, size: size));
    notifyListeners();
  }

  void updateQuantity(CartItem cartItem, int quantity) {
    if (quantity == 0) {
      _cartItems.remove(cartItem);
    } else {
      cartItem.quantity = quantity;
    }
    notifyListeners();
  }

  void updateItemPrice(CartItem cartItem, double price) {
    cartItem.itemPrice = price;
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double get totalPrice {
    return _cartItems.fold(
        0.0, (sum, item) => sum + (item.itemPrice * item.quantity));
  }

  int get totalQuantity {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  Future<void> submitCart(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    final transaction = {
      "userId": userId,
      "timestamp": DateTime.now().toIso8601String(),
      "TotalPrice": totalPrice,
      "totalQuantity": totalQuantity,
      "Items": _cartItems
          .map((cartItem) => {
                "itemId": cartItem.item.id,
                "quantity": cartItem.quantity,
                "size": cartItem.size.value,
                "itemPrice": cartItem.itemPrice,
              })
          .toList(),
    };
    final transactionJson = jsonEncode(transaction);
    print(transactionJson);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/API/Skirpsi/SubmitThisTrans'),
        headers: {'Content-Type': 'application/json'},
        body: transactionJson,
      );

      if (response.statusCode == 200) {
        clearCart();
        _showSuccessDialog(context);
      } else {
        final errorResponse = jsonDecode(response.body);
        String errorMessage = errorResponse['message'] ??
            'Failed to submit the transaction. Please try again later.';
        _showErrorDialog(context, errorMessage);
      }
    } catch (e) {
      _showErrorDialog(context,
          'Network error occurred. Please check your internet connection and try again.');
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Icon(
            Icons.check,
            color: Colors.green,
            size: 64,
          ),
          content: const Text('Transaction successfully submitted!'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Icon(
            Icons.error,
            color: Colors.red,
            size: 64,
          ),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
          ],
        );
      },
    );
  }
}
