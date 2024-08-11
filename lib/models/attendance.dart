class Attendance {
  final int id;
  final DateTime checkInTime;
  final DateTime checkOutTime;

  Attendance({
    required this.id,
    required this.checkInTime,
    required this.checkOutTime,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      checkInTime: DateTime.parse(json['checkIntime']),
      checkOutTime: DateTime.parse(json['checkOuttime']),
    );
  }
}
