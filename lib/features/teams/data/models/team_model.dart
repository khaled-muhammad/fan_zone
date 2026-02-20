class TeamModel {
  final String id;
  final String name;
  final String captainId;
  final String? captainName;
  final List<TeamPlayer> players;
  final int maxPlayers;
  final bool isComplete;

  TeamModel({
    required this.id,
    required this.name,
    required this.captainId,
    this.captainName,
    required this.players,
    required this.maxPlayers,
    required this.isComplete,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    final captain = json['captainId'];
    return TeamModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      captainId: captain is Map ? captain['_id'] ?? '' : (captain ?? ''),
      captainName: captain is Map ? captain['fullName'] : null,
      players: (json['players'] as List<dynamic>?)
              ?.map((p) => TeamPlayer.fromJson(p is Map<String, dynamic> ? p : {'_id': p}))
              .toList() ??
          [],
      maxPlayers: json['maxPlayers'] ?? 10,
      isComplete: json['isComplete'] ?? false,
    );
  }
}

class TeamPlayer {
  final String id;
  final String? fullName;
  final String? position;
  final String? level;

  TeamPlayer({required this.id, this.fullName, this.position, this.level});

  factory TeamPlayer.fromJson(Map<String, dynamic> json) {
    return TeamPlayer(
      id: json['_id'] ?? '',
      fullName: json['fullName'],
      position: json['position'],
      level: json['level'],
    );
  }
}
