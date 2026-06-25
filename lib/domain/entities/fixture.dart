/// Fixture entity — represents a scheduled match.
class Fixture {
  final String id;
  final String tournamentId;
  final String tournamentName;
  final String sportType;
  final String teamAId;
  final String teamBId;
  final String teamAName;
  final String teamBName;
  final String teamALogo;
  final String teamBLogo;
  final DateTime? date;
  final String time;
  final String venue;
  final String status;

  const Fixture({
    required this.id,
    required this.tournamentId,
    this.tournamentName = "",
    this.sportType = "",
    required this.teamAId,
    required this.teamBId,
    required this.teamAName,
    required this.teamBName,
    this.teamALogo = "",
    this.teamBLogo = "",
    this.date,
    this.time = "",
    this.venue = "",
    this.status = "upcoming",
  });

  Fixture copyWith({
    String? id,
    String? tournamentId,
    String? tournamentName,
    String? sportType,
    String? teamAId,
    String? teamBId,
    String? teamAName,
    String? teamBName,
    String? teamALogo,
    String? teamBLogo,
    DateTime? date,
    String? time,
    String? venue,
    String? status,
  }) {
    return Fixture(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      tournamentName: tournamentName ?? this.tournamentName,
      sportType: sportType ?? this.sportType,
      teamAId: teamAId ?? this.teamAId,
      teamBId: teamBId ?? this.teamBId,
      teamAName: teamAName ?? this.teamAName,
      teamBName: teamBName ?? this.teamBName,
      teamALogo: teamALogo ?? this.teamALogo,
      teamBLogo: teamBLogo ?? this.teamBLogo,
      date: date ?? this.date,
      time: time ?? this.time,
      venue: venue ?? this.venue,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Fixture && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
