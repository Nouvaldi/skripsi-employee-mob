import 'package:employee_mobile/models/item_model.dart';
import 'package:flutter/material.dart';

class Shop extends ChangeNotifier{
  final List<Item> _shop = [
    Item(id: 1, name: 'shirt a', price: 10, description: 'description'),
    Item(id: 2, name: 'shirt b', price: 12, description: 'description'),
    Item(id: 3, name: 'shirt c', price: 15, description: 'description'),
    Item(id: 4, name: 'shirt d', price: 20, description: 'description'),
  ];
  
  List<Item> _cart = [];

  List<Item> get shop => _shop;

  List<Item> get cart => _cart;

  void addToCart(Item item) {
    _cart.add(item);
    notifyListeners();
  }

  void removeFromCart(Item item) {
    _cart.remove(item);
    notifyListeners();
  }
}