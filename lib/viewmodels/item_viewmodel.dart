import 'package:employee_mobile/config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/item.dart';

class ItemViewModel with ChangeNotifier {
  List<Item> _items = [];
  List<Item> _filteredItems = [];
  bool _loading = false;

  List<Item> get items => _filteredItems;
  bool get loading => _loading;

  Future<void> fetchItems() async {
    _loading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/API/Skripsi/ReadMasterItem'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final List<dynamic> data = jsonResponse['Data'];
        _items = data.map((item) => Item.fromJson(item)).toList();
        _filteredItems = _items;
      }
    } catch (error) {
      print('error');
    }

    _loading = false;
    notifyListeners();
  }

  void searchItems(String query) {
    if (query.isEmpty) {
      _filteredItems = _items;
    } else {
      _filteredItems = _items
          .where((item) =>
              item.itemName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
