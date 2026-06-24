import "package:cloud_firestore/cloud_firestore.dart";
import "package:sportsboard/domain/entities/player.dart";

/// Firestore-aware model for Player entity.
class PlayerModel extends Player {
  const PlayerModel({
    required super.id,
    required super.teamId,
    super.teamName,
    super.sportId,
    required super.name,
    super.className,
    super.rollNo,
    super.photoUrl,
  });

  factory PlayerModel.fromEntity(Player p) {
    return PlayerModel(
      id: p.id,
      teamId: p.teamId,
      teamName: p.teamName,
      sportId: p.sportId,
      name: p.name,
      className: p.className,
      rollNo: p.rollNo,
      photoUrl: p.photoUrl,
    );
  }

  factory PlayerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return PlayerModel(
      id: doc.id,
      teamId: data["teamId"] as String? ?? "",
      teamName: data["teamName"] as String? ?? "",
      sportId: data["sportId"] as String? ?? "",
      name: data["name"] as String? ?? "",
      className: data["className"] as String? ?? "",
      rollNo: data["rollNo"] as String? ?? "",
      photoUrl: data["photoUrl"] as String? ?? "",
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "teamId": teamId,
      "teamName": teamName,
      "sportId": sportId,
      "name": name,
      "className": className,
      "rollNo": rollNo,
      "photoUrl": photoUrl,
    };
  }
}
