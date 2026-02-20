class OwnerStatsModel {
  final int totalPitches;
  final int totalBookings;
  final int todayBookings;
  final int checkedIn;
  final int completed;

  OwnerStatsModel({
    required this.totalPitches,
    required this.totalBookings,
    required this.todayBookings,
    required this.checkedIn,
    required this.completed,
  });

  factory OwnerStatsModel.fromJson(Map<String, dynamic> json) {
    return OwnerStatsModel(
      totalPitches: json['totalPitches'] ?? 0,
      totalBookings: json['totalBookings'] ?? 0,
      todayBookings: json['todayBookings'] ?? 0,
      checkedIn: json['checkedIn'] ?? 0,
      completed: json['completed'] ?? 0,
    );
  }
}
