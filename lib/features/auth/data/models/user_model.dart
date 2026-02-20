class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String? phone;
  final String? position;
  final int goals;
  final int assists;
  final int matchesPlayed;
  final String level;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.phone,
    this.position,
    this.goals = 0,
    this.assists = 0,
    this.matchesPlayed = 0,
    this.level = 'Bronze',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'player',
      phone: json['phone'],
      position: json['position'],
      goals: json['goals'] ?? 0,
      assists: json['assists'] ?? 0,
      matchesPlayed: json['matchesPlayed'] ?? 0,
      level: json['level'] ?? 'Bronze',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'fullName': fullName,
        'email': email,
        'role': role,
        'phone': phone,
        'position': position,
        'goals': goals,
        'assists': assists,
        'matchesPlayed': matchesPlayed,
        'level': level,
      };
}
