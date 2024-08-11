import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:employee_mobile/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../components/my_card.dart';
import '../components/my_elevated_button.dart';
import '../config.dart';
import '../viewmodels/login_viewmodel.dart';
import 'camera_view.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  Position? _currentPosition;
  List<CameraDescription>? _cameras;
  File? _imageFile;
  DateTime? _checkInTime;
  DateTime? _checkOutTime;

  DateTime? get checkInTime => _checkInTime;
  DateTime? get checkOutTime => _checkOutTime;

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndInitialize();
  }

  void _requestPermissionsAndInitialize() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationWhenInUse,
      Permission.camera,
    ].request();

    if (statuses[Permission.locationWhenInUse]!.isGranted &&
        statuses[Permission.camera]!.isGranted) {
      _getCurrentLocation();
      _initializeCameras();
    } else {
      print('Permissions not granted');
    }
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = position;
    });
  }

  void _initializeCameras() async {
    _cameras = await availableCameras();
    setState(() {});
  }

  void _navigateToCameraPreview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraPreviewPage(
          cameras: _cameras!,
          onPictureTaken: (file) {
            setState(() {
              _imageFile = file;
            });
          },
        ),
      ),
    );
  }

  void _submitAttendance(BuildContext context) async {
    final prefs = Provider.of<LoginViewModel>(context, listen: false);
    // final username = prefs.username;
    final userId = prefs.userId;

    if (_imageFile == null || _currentPosition == null) {
      _showErrorDialog(
          context, 'Please ensure both photo and location are provided.');
      return;
    }

    List<int> imageBytes = _imageFile!.readAsBytesSync();
    String base64String = base64.encode(imageBytes);

    final checkIn = {
      // "id": 1,
      "userId": userId,
      "locationId": 1,
      "activityTimestamp": DateTime.now().toIso8601String(),
      "lat": _currentPosition!.latitude.toString(),
      "lng": _currentPosition!.longitude.toString(),
      "photo": base64String,
    };
    final String checkInJson = jsonEncode(checkIn);
    print(checkInJson);

    final checkOut = {
      "userId": userId,
      "CheckoutTimestamp": DateTime.now().toIso8601String(),
      "lat": _currentPosition!.latitude,
      "lng": _currentPosition!.longitude,
    };
    final String checkOutJson = jsonEncode(checkOut);
    print(checkOutJson);

    final attendanceResponse = await http.post(
      Uri.parse('$baseUrl/API/Skripsi/GetAcitivity'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
      }),
    );

    if (_currentPosition != null && _imageFile != null) {
      try {
        if (attendanceResponse.statusCode == 200) {
          final attendanceJson = jsonDecode(attendanceResponse.body);
          if (attendanceJson != null) {
            // check out
            try {
              final url = Uri.parse('$baseUrl/API/Skripsi/CheckOutActivity');
              final response = await http.post(
                url,
                headers: {'Content-Type': 'application/json'},
                body: checkOutJson,
              );

              if (response.statusCode == 200) {
                _showSuccessDialog(context, 'Check out successful.');
              } else {
                _showErrorDialog(
                    context, 'Failed to check out: ${response.statusCode}');
              }
            } catch (e) {
              _showErrorDialog(context, 'Check out error: $e');
            }
          } else {
            // check in
            try {
              final url = Uri.parse('$baseUrl/API/Skripsi/CheckInActivity');
              final response = await http.post(
                url,
                headers: {'Content-Type': 'application/json'},
                body: checkInJson,
              );

              if (response.statusCode == 200) {
                _showSuccessDialog(context, 'Check in successful.');
              } else {
                _showErrorDialog(
                    context, 'Failed to check in: ${response.statusCode}');
              }
            } catch (e) {
              _showErrorDialog(context, 'Check in error: $e');
            }
          }
        } else {
          _showErrorDialog(
            context,
            'Error fetching data. \nPlease check your connection.',
          );
        }
      } catch (e) {
        _showErrorDialog(context, 'Error submitting attendance: $e');
      }
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Icon(
            Icons.check,
            color: Colors.green,
            size: 64,
          ),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              ),
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

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final formattedTime = DateFormat('HH:mm').format(now);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Attendance'),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _currentPosition == null || _cameras == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    MyCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Time: ',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            formattedTime,
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    MyCard(
                      child: Container(
                        child: _imageFile != null
                            ? Image.file(
                                _imageFile!,
                                height: 400,
                              )
                            : Container(
                                height: 400,
                                color: Colors.grey,
                                child: const Center(
                                  child: Text(
                                    'Press the button below \nto take a screenshot.',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(height: 16),
                    MyElevatedButton(
                      onPressed: _navigateToCameraPreview,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take Photo'),
                    ),
                    const SizedBox(height: 8),
                    MyElevatedButton(
                      onPressed: () => _submitAttendance(context),
                      icon: const Icon(Icons.access_alarm),
                      label: const Text('Submit Attendance'),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}
