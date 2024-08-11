import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/attendance_history.dart';

class AttendanceHistoryViewModel with ChangeNotifier {
  List<AttendanceHistory> _history = [];
  bool _loading = false;
  String? _username;
  int? _userId;

  List<AttendanceHistory> get history => _history;
  bool get loading => _loading;
  String? get username => _username;
  int? get userId => _userId;

  Future<void> fetchAttendanceHistory() async {
    _loading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _userId = prefs.getInt('userId');
      _username = prefs.getString('username');

      final response = await http.post(
        Uri.parse('$baseUrl/API/Skripsi/GetRecentActivity'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': _userId,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _history =
            data.map((json) => AttendanceHistory.fromJson(json)).toList();
      }
    } catch (error) {
      print('Error fetching transactions: $error');
    }

    _loading = false;
    notifyListeners();
  }
}
