import 'package:employee_mobile/models/size_enum.dart';

import 'item.dart';

class CartItem {
  final Item item;
  final ItemSize size;
  int quantity;
  double itemPrice;

  CartItem({
    required this.item,
    required this.size,
    this.quantity = 1,
    this.itemPrice = 0.0,
  });
}