class AttendanceHistory {
  final int id;
  final DateTime checkInTime;
  final DateTime checkOutTime;

  AttendanceHistory({
    required this.id,
    required this.checkInTime,
    required this.checkOutTime,
  });

  factory AttendanceHistory.fromJson(Map<String, dynamic> json) {
    return AttendanceHistory(
      id: json['id'],
      checkInTime: DateTime.parse(json['checkIntime']),
      checkOutTime: DateTime.parse(json['checkOuttime']),
    );
  }
}