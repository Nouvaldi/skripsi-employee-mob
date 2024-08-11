class Announcement {
  final int id;
  final String announcement;

  Announcement({
    required this.id,
    required this.announcement,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      announcement: json['announcment'],
    );
  }
}
