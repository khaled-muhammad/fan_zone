class PitchModel {
  final String id;
  final String name;
  final String locationName;
  final double latitude;
  final double longitude;
  final double pricePerHour;
  final List<String> images;
  final int workingHoursStart;
  final int workingHoursEnd;
  final double rating;
  final String? mapsUrl;
  final String? createdByName;

  PitchModel({
    required this.id,
    required this.name,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.pricePerHour,
    required this.images,
    required this.workingHoursStart,
    required this.workingHoursEnd,
    required this.rating,
    this.mapsUrl,
    this.createdByName,
  });

  factory PitchModel.fromJson(Map<String, dynamic> json) {
    return PitchModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      locationName: json['locationName'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      pricePerHour: (json['pricePerHour'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      workingHoursStart: json['workingHoursStart'] ?? 8,
      workingHoursEnd: json['workingHoursEnd'] ?? 24,
      rating: (json['rating'] ?? 0).toDouble(),
      mapsUrl: json['mapsUrl'] as String?,
      createdByName: json['createdBy'] is Map ? json['createdBy']['fullName'] : null,
    );
  }
}

class TimeSlot {
  final String time;
  final bool available;

  TimeSlot({required this.time, required this.available});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      time: json['time'] ?? '',
      available: json['available'] ?? false,
    );
  }
}
