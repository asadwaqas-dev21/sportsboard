/// Team entity — represents a team in a tournament.
class Team {
  final String id;
  final String tournamentId;
  final String name;
  final String logoUrl;
  final String captainId;
  final String captainName;

  const Team({
    required this.id,
    required this.tournamentId,
    required this.name,
    this.logoUrl = "",
    this.captainId = "",
    this.captainName = "",
  });

  Team copyWith({
    String? id,
    String? tournamentId,
    String? name,
    String? logoUrl,
    String? captainId,
    String? captainName,
  }) {
    return Team(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      captainId: captainId ?? this.captainId,
      captainName: captainName ?? this.captainName,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Team && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
