class LeagueModel {
  final String id;
  final String name;
  final String? pitchId;
  final String? pitchName;
  final DateTime startDate;
  final int maxTeams;
  final List<LeagueTeam> teams;
  final List<LeagueMatch> matches;
  final List<Standing> standings;

  LeagueModel({
    required this.id,
    required this.name,
    this.pitchId,
    this.pitchName,
    required this.startDate,
    required this.maxTeams,
    required this.teams,
    required this.matches,
    required this.standings,
  });

  factory LeagueModel.fromJson(Map<String, dynamic> json) {
    final pitch = json['pitchId'];
    return LeagueModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      pitchId: pitch is Map ? pitch['_id'] : pitch,
      pitchName: pitch is Map ? pitch['name'] : null,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      maxTeams: json['maxTeams'] ?? 8,
      teams: (json['teams'] as List<dynamic>?)
              ?.map((t) => LeagueTeam.fromJson(t is Map<String, dynamic> ? t : {'_id': t}))
              .toList() ??
          [],
      matches: (json['matches'] as List<dynamic>?)
              ?.map((m) => LeagueMatch.fromJson(m))
              .toList() ??
          [],
      standings: (json['standings'] as List<dynamic>?)
              ?.map((s) => Standing.fromJson(s))
              .toList() ??
          [],
    );
  }
}

class LeagueTeam {
  final String id;
  final String? name;

  LeagueTeam({required this.id, this.name});

  factory LeagueTeam.fromJson(Map<String, dynamic> json) {
    return LeagueTeam(id: json['_id'] ?? '', name: json['name']);
  }
}

class LeagueMatch {
  final String? homeTeamId;
  final String? homeTeamName;
  final String? awayTeamId;
  final String? awayTeamName;
  final int homeScore;
  final int awayScore;
  final bool played;

  LeagueMatch({
    this.homeTeamId,
    this.homeTeamName,
    this.awayTeamId,
    this.awayTeamName,
    this.homeScore = 0,
    this.awayScore = 0,
    this.played = false,
  });

  factory LeagueMatch.fromJson(Map<String, dynamic> json) {
    final home = json['homeTeam'];
    final away = json['awayTeam'];
    return LeagueMatch(
      homeTeamId: home is Map ? home['_id'] : home,
      homeTeamName: home is Map ? home['name'] : null,
      awayTeamId: away is Map ? away['_id'] : away,
      awayTeamName: away is Map ? away['name'] : null,
      homeScore: json['homeScore'] ?? 0,
      awayScore: json['awayScore'] ?? 0,
      played: json['played'] ?? false,
    );
  }
}

class Standing {
  final String? teamId;
  final String? teamName;
  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int goalsFor;
  final int goalsAgainst;
  final int points;

  Standing({
    this.teamId,
    this.teamName,
    this.played = 0,
    this.won = 0,
    this.drawn = 0,
    this.lost = 0,
    this.goalsFor = 0,
    this.goalsAgainst = 0,
    this.points = 0,
  });

  int get goalDifference => goalsFor - goalsAgainst;

  factory Standing.fromJson(Map<String, dynamic> json) {
    final team = json['team'];
    return Standing(
      teamId: team is Map ? team['_id'] : team,
      teamName: team is Map ? team['name'] : null,
      played: json['played'] ?? 0,
      won: json['won'] ?? 0,
      drawn: json['drawn'] ?? 0,
      lost: json['lost'] ?? 0,
      goalsFor: json['goalsFor'] ?? 0,
      goalsAgainst: json['goalsAgainst'] ?? 0,
      points: json['points'] ?? 0,
    );
  }
}
