import "package:cloud_firestore/cloud_firestore.dart";
import "package:sportsboard/domain/entities/team.dart";

/// Firestore-aware model for Team entity.
class TeamModel extends Team {
  const TeamModel({
    required super.id,
    required super.tournamentId,
    required super.name,
    super.logoUrl,
    super.captainId,
    super.captainName,
  });

  factory TeamModel.fromEntity(Team t) {
    return TeamModel(
      id: t.id,
      tournamentId: t.tournamentId,
      name: t.name,
      logoUrl: t.logoUrl,
      captainId: t.captainId,
      captainName: t.captainName,
    );
  }

  factory TeamModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return TeamModel(
      id: doc.id,
      tournamentId: data["tournamentId"] as String? ?? "",
      name: data["name"] as String? ?? "",
      logoUrl: data["logoUrl"] as String? ?? "",
      captainId: data["captainId"] as String? ?? "",
      captainName: data["captainName"] as String? ?? "",
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "tournamentId": tournamentId,
      "name": name,
      "logoUrl": logoUrl,
      "captainId": captainId,
      "captainName": captainName,
    };
  }
}
