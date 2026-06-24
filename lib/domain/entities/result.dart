/// Result entity — represents a match result.
class Result {
  final String id;
  final String fixtureId;
  final String tournamentId;
  final String sportType;
  final String winnerTeamId;
  final String loserTeamId;
  final String teamAName;
  final String teamBName;
  final String scoreSummary;
  final String resultText;
  final String addedBy;
  final DateTime? createdAt;
  // Cricket-specific
  final Map<String, dynamic>? cricketData;
  // Football-specific
  final Map<String, dynamic>? footballData;
  // Indoor-specific
  final Map<String, dynamic>? indoorData;

  const Result({
    required this.id,
    required this.fixtureId,
    required this.tournamentId,
    this.sportType = "",
    this.winnerTeamId = "",
    this.loserTeamId = "",
    this.teamAName = "",
    this.teamBName = "",
    this.scoreSummary = "",
    this.resultText = "",
    this.addedBy = "",
    this.createdAt,
    this.cricketData,
    this.footballData,
    this.indoorData,
  });

  Result copyWith({
    String? id,
    String? fixtureId,
    String? tournamentId,
    String? sportType,
    String? winnerTeamId,
    String? loserTeamId,
    String? teamAName,
    String? teamBName,
    String? scoreSummary,
    String? resultText,
    String? addedBy,
    DateTime? createdAt,
    Map<String, dynamic>? cricketData,
    Map<String, dynamic>? footballData,
    Map<String, dynamic>? indoorData,
  }) {
    return Result(
      id: id ?? this.id,
      fixtureId: fixtureId ?? this.fixtureId,
      tournamentId: tournamentId ?? this.tournamentId,
      sportType: sportType ?? this.sportType,
      winnerTeamId: winnerTeamId ?? this.winnerTeamId,
      loserTeamId: loserTeamId ?? this.loserTeamId,
      teamAName: teamAName ?? this.teamAName,
      teamBName: teamBName ?? this.teamBName,
      scoreSummary: scoreSummary ?? this.scoreSummary,
      resultText: resultText ?? this.resultText,
      addedBy: addedBy ?? this.addedBy,
      createdAt: createdAt ?? this.createdAt,
      cricketData: cricketData ?? this.cricketData,
      footballData: footballData ?? this.footballData,
      indoorData: indoorData ?? this.indoorData,
    );
  }
}
