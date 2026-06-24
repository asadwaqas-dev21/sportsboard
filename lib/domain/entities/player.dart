/// Player entity — represents a player.
class Player {
  final String id;
  final String teamId;
  final String teamName;
  final String sportId;
  final String name;
  final String className;
  final String rollNo;
  final String photoUrl;

  const Player({
    required this.id,
    required this.teamId,
    this.teamName = "",
    this.sportId = "",
    required this.name,
    this.className = "",
    this.rollNo = "",
    this.photoUrl = "",
  });

  Player copyWith({
    String? id,
    String? teamId,
    String? teamName,
    String? sportId,
    String? name,
    String? className,
    String? rollNo,
    String? photoUrl,
  }) {
    return Player(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      sportId: sportId ?? this.sportId,
      name: name ?? this.name,
      className: className ?? this.className,
      rollNo: rollNo ?? this.rollNo,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
