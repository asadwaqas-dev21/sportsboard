/// Tournament entity — represents a tournament/league.
class Tournament {
  final String id;
  final String sportId;
  final String sportName;
  final String name;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status;

  const Tournament({
    required this.id,
    required this.sportId,
    this.sportName = "",
    required this.name,
    this.startDate,
    this.endDate,
    this.status = "upcoming",
  });

  Tournament copyWith({
    String? id,
    String? sportId,
    String? sportName,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) {
    return Tournament(
      id: id ?? this.id,
      sportId: sportId ?? this.sportId,
      sportName: sportName ?? this.sportName,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tournament && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
