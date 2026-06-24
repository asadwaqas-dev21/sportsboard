import "package:cloud_firestore/cloud_firestore.dart";
import "package:sportsboard/domain/entities/fixture.dart";

/// Firestore-aware model for Fixture entity.
class FixtureModel extends Fixture {
  const FixtureModel({
    required super.id,
    required super.tournamentId,
    super.tournamentName,
    super.sportType,
    required super.teamAId,
    required super.teamBId,
    required super.teamAName,
    required super.teamBName,
    super.teamALogo,
    super.teamBLogo,
    super.date,
    super.time,
    super.venue,
    super.status,
  });

  factory FixtureModel.fromEntity(Fixture f) {
    return FixtureModel(
      id: f.id,
      tournamentId: f.tournamentId,
      tournamentName: f.tournamentName,
      sportType: f.sportType,
      teamAId: f.teamAId,
      teamBId: f.teamBId,
      teamAName: f.teamAName,
      teamBName: f.teamBName,
      teamALogo: f.teamALogo,
      teamBLogo: f.teamBLogo,
      date: f.date,
      time: f.time,
      venue: f.venue,
      status: f.status,
    );
  }

  factory FixtureModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return FixtureModel(
      id: doc.id,
      tournamentId: data["tournamentId"] as String? ?? "",
      tournamentName: data["tournamentName"] as String? ?? "",
      sportType: data["sportType"] as String? ?? "",
      teamAId: data["teamAId"] as String? ?? "",
      teamBId: data["teamBId"] as String? ?? "",
      teamAName: data["teamAName"] as String? ?? "",
      teamBName: data["teamBName"] as String? ?? "",
      teamALogo: data["teamALogo"] as String? ?? "",
      teamBLogo: data["teamBLogo"] as String? ?? "",
      date: (data["date"] as Timestamp?)?.toDate(),
      time: data["time"] as String? ?? "",
      venue: data["venue"] as String? ?? "",
      status: data["status"] as String? ?? "upcoming",
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "tournamentId": tournamentId,
      "tournamentName": tournamentName,
      "sportType": sportType,
      "teamAId": teamAId,
      "teamBId": teamBId,
      "teamAName": teamAName,
      "teamBName": teamBName,
      "teamALogo": teamALogo,
      "teamBLogo": teamBLogo,
      "date": date != null ? Timestamp.fromDate(date!) : null,
      "time": time,
      "venue": venue,
      "status": status,
    };
  }
}
