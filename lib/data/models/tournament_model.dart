import "package:cloud_firestore/cloud_firestore.dart";
import "package:sportsboard/domain/entities/tournament.dart";

/// Firestore-aware model for Tournament entity.
class TournamentModel extends Tournament {
  const TournamentModel({
    required super.id,
    required super.sportId,
    super.sportName,
    required super.name,
    super.startDate,
    super.endDate,
    super.status,
  });

  factory TournamentModel.fromEntity(Tournament t) {
    return TournamentModel(
      id: t.id,
      sportId: t.sportId,
      sportName: t.sportName,
      name: t.name,
      startDate: t.startDate,
      endDate: t.endDate,
      status: t.status,
    );
  }

  factory TournamentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return TournamentModel(
      id: doc.id,
      sportId: data["sportId"] as String? ?? "",
      sportName: data["sportName"] as String? ?? "",
      name: data["name"] as String? ?? "",
      startDate: (data["startDate"] as Timestamp?)?.toDate(),
      endDate: (data["endDate"] as Timestamp?)?.toDate(),
      status: data["status"] as String? ?? "upcoming",
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "sportId": sportId,
      "sportName": sportName,
      "name": name,
      "startDate": startDate != null ? Timestamp.fromDate(startDate!) : null,
      "endDate": endDate != null ? Timestamp.fromDate(endDate!) : null,
      "status": status,
    };
  }
}
