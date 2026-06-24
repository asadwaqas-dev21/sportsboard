/// PlayerStats entity — aggregated stats for a player in a tournament.
class PlayerStats {
  final String id;
  final String tournamentId;
  final String playerId;
  final String playerName;
  final String teamId;
  final String teamName;
  final String sportType;
  // Cricket batting
  final int runs;
  final int balls;
  final int fours;
  final int sixes;
  final int matches;
  // Cricket bowling
  final int wickets;
  final int maidens;
  final double overs;
  final int runsConceded;
  final int catches;
  // Football
  final int goals;
  final int assists;
  final int cleanSheets;
  final int yellowCards;
  final int redCards;
  final int manOfMatch;
  // Calculated
  final int rankingPoints;

  const PlayerStats({
    required this.id,
    required this.tournamentId,
    required this.playerId,
    this.playerName = "",
    this.teamId = "",
    this.teamName = "",
    this.sportType = "",
    this.runs = 0,
    this.balls = 0,
    this.fours = 0,
    this.sixes = 0,
    this.matches = 0,
    this.wickets = 0,
    this.maidens = 0,
    this.overs = 0.0,
    this.runsConceded = 0,
    this.catches = 0,
    this.goals = 0,
    this.assists = 0,
    this.cleanSheets = 0,
    this.yellowCards = 0,
    this.redCards = 0,
    this.manOfMatch = 0,
    this.rankingPoints = 0,
  });

  /// Cricket batting strike rate.
  double get strikeRate =>
      balls > 0 ? (runs / balls) * 100 : 0.0;

  /// Cricket bowling economy.
  double get economy =>
      overs > 0 ? runsConceded / overs : 0.0;

  /// Cricket batting average (simplified: runs / matches).
  double get battingAverage =>
      matches > 0 ? runs / matches : 0.0;

  /// Cricket bowling average (simplified: runsConceded / wickets).
  double get bowlingAverage =>
      wickets > 0 ? runsConceded / wickets : 0.0;

  PlayerStats copyWith({
    String? id,
    String? tournamentId,
    String? playerId,
    String? playerName,
    String? teamId,
    String? teamName,
    String? sportType,
    int? runs,
    int? balls,
    int? fours,
    int? sixes,
    int? matches,
    int? wickets,
    int? maidens,
    double? overs,
    int? runsConceded,
    int? catches,
    int? goals,
    int? assists,
    int? cleanSheets,
    int? yellowCards,
    int? redCards,
    int? manOfMatch,
    int? rankingPoints,
  }) {
    return PlayerStats(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      sportType: sportType ?? this.sportType,
      runs: runs ?? this.runs,
      balls: balls ?? this.balls,
      fours: fours ?? this.fours,
      sixes: sixes ?? this.sixes,
      matches: matches ?? this.matches,
      wickets: wickets ?? this.wickets,
      maidens: maidens ?? this.maidens,
      overs: overs ?? this.overs,
      runsConceded: runsConceded ?? this.runsConceded,
      catches: catches ?? this.catches,
      goals: goals ?? this.goals,
      assists: assists ?? this.assists,
      cleanSheets: cleanSheets ?? this.cleanSheets,
      yellowCards: yellowCards ?? this.yellowCards,
      redCards: redCards ?? this.redCards,
      manOfMatch: manOfMatch ?? this.manOfMatch,
      rankingPoints: rankingPoints ?? this.rankingPoints,
    );
  }
}
