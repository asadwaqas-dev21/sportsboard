/// Standing entity — represents a team's position in a tournament.
class Standing {
  final String id;
  final String tournamentId;
  final String teamId;
  final String teamName;
  final int played;
  final int won;
  final int lost;
  final int draw;
  final int points;
  // Cricket extras
  final double netRunRate;
  // Football extras
  final int goalsFor;
  final int goalsAgainst;
  final int goalDifference;

  const Standing({
    required this.id,
    required this.tournamentId,
    required this.teamId,
    this.teamName = "",
    this.played = 0,
    this.won = 0,
    this.lost = 0,
    this.draw = 0,
    this.points = 0,
    this.netRunRate = 0.0,
    this.goalsFor = 0,
    this.goalsAgainst = 0,
    this.goalDifference = 0,
  });

  Standing copyWith({
    String? id,
    String? tournamentId,
    String? teamId,
    String? teamName,
    int? played,
    int? won,
    int? lost,
    int? draw,
    int? points,
    double? netRunRate,
    int? goalsFor,
    int? goalsAgainst,
    int? goalDifference,
  }) {
    return Standing(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      played: played ?? this.played,
      won: won ?? this.won,
      lost: lost ?? this.lost,
      draw: draw ?? this.draw,
      points: points ?? this.points,
      netRunRate: netRunRate ?? this.netRunRate,
      goalsFor: goalsFor ?? this.goalsFor,
      goalsAgainst: goalsAgainst ?? this.goalsAgainst,
      goalDifference: goalDifference ?? this.goalDifference,
    );
  }
}
