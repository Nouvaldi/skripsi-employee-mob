import 'dart:convert';
import 'package:employee_mobile/config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/announcement.dart';
import '../models/attendance.dart';

class HomeViewModel with ChangeNotifier {
  List<Announcement> _announcements = [];
  List<Attendance> _attendanceRecords = [];
  DateTime? _checkInTime;
  DateTime? _checkOutTime;
  bool _loading = false;
  String? _errorMessage;
  String? _username;
  int? _userId;

  List<Announcement> get announcements => _announcements;
  List<Attendance> get attendanceRecords => _attendanceRecords;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  String? get username => _username;
  int? get userId => _userId;
  DateTime? get checkInTime => _checkInTime;
  DateTime? get checkOutTime => _checkOutTime;

  Future<void> fetchHomeData() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _userId = prefs.getInt('userId');
      _username = prefs.getString('username');

      if (_userId == null || _username == null) {
        _errorMessage = 'User not found. Please try log in again.';
        _loading = false;
        notifyListeners();
        return;
      }

      final announcementsResponse =
          await http.get(Uri.parse('$baseUrl/API/Skripsi/ReadAnnouncment'));

      if (announcementsResponse.statusCode == 200) {
        final announcementsJson =
            jsonDecode(announcementsResponse.body) as List;
        _announcements = announcementsJson
            .map((data) => Announcement.fromJson(data))
            .toList();
      } else if (announcementsResponse.statusCode == 500) {
        _announcements = [];
      } else {
        _errorMessage =
            'Error fetching announcements: ${announcementsResponse.statusCode}';
      }

      final attendanceResponse = await http.post(
        Uri.parse('$baseUrl/API/Skripsi/GetAcitivity'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': _userId,
        }),
      );

      if (attendanceResponse.statusCode == 200) {
        final attendanceJson = jsonDecode(attendanceResponse.body);
        print(attendanceJson);
        if (attendanceJson != null) {
          _checkInTime = DateTime.parse(attendanceJson['checkIntime']);
          _checkOutTime = DateTime.parse(attendanceJson['checkOuttime']);
        }
        print(_checkInTime);
        print(_checkOutTime);
      } else {
        _errorMessage =
            'Error fetching attendance data: ${attendanceResponse.statusCode} \nSwipe down to refresh.';
      }
    } catch (error) {
      _errorMessage = 'Error fetching data. \nPlease check your connection. \nSwipe down to refresh.';
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('userId');
    notifyListeners();
  }
}
