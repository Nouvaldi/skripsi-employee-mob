import 'dart:convert';
import 'package:employee_mobile/config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel with ChangeNotifier {
  String? _username;
  int? _userId;

  String? get username => _username;
  int? get userId => _userId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    // for debugging local comment
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('username', username);
    // await prefs.setInt('userId', 6);
    // return true;

    final response = await http.post(
      Uri.parse('$baseUrl/API/Skripsi/Login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    _isLoading = false;
    notifyListeners();

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final userId = jsonResponse['userId'];
      final success = jsonResponse['success'];

      // Save user information
      if (success == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setInt('userId', userId);
        print(userId);
        print(username);
        return true;
      }
    }
    return false;
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
    _userId = prefs.getInt('userId');
    notifyListeners();
  }
}
