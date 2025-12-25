class Clinic {
  final String name;
  final List<String> days;
  final String timeFrom;
  final String timeTo;
  final String location;
  final String phone;

  Clinic({
    required this.name,
    required this.days,
    required this.timeFrom,
    required this.timeTo,
    required this.location,
    required this.phone,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      name: json['name'] ?? '',
      days:
          (json['days'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      timeFrom: json['time_from']?.toString() ?? '',
      timeTo: json['time_to']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
    );
  }
}
