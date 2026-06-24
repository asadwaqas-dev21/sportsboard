import "package:cloud_firestore/cloud_firestore.dart";
import "package:sportsboard/domain/entities/standing.dart";

/// Firestore-aware model for Standing entity.
class StandingModel extends Standing {
  const StandingModel({
    required super.id,
    required super.tournamentId,
    required super.teamId,
    super.teamName,
    super.played,
    super.won,
    super.lost,
    super.draw,
    super.points,
    super.netRunRate,
    super.goalsFor,
    super.goalsAgainst,
    super.goalDifference,
  });

  factory StandingModel.fromEntity(Standing s) {
    return StandingModel(
      id: s.id,
      tournamentId: s.tournamentId,
      teamId: s.teamId,
      teamName: s.teamName,
      played: s.played,
      won: s.won,
      lost: s.lost,
      draw: s.draw,
      points: s.points,
      netRunRate: s.netRunRate,
      goalsFor: s.goalsFor,
      goalsAgainst: s.goalsAgainst,
      goalDifference: s.goalDifference,
    );
  }

  factory StandingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return StandingModel(
      id: doc.id,
      tournamentId: data["tournamentId"] as String? ?? "",
      teamId: data["teamId"] as String? ?? "",
      teamName: data["teamName"] as String? ?? "",
      played: data["played"] as int? ?? 0,
      won: data["won"] as int? ?? 0,
      lost: data["lost"] as int? ?? 0,
      draw: data["draw"] as int? ?? 0,
      points: data["points"] as int? ?? 0,
      netRunRate: (data["netRunRate"] as num?)?.toDouble() ?? 0.0,
      goalsFor: data["goalsFor"] as int? ?? 0,
      goalsAgainst: data["goalsAgainst"] as int? ?? 0,
      goalDifference: data["goalDifference"] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "tournamentId": tournamentId,
      "teamId": teamId,
      "teamName": teamName,
      "played": played,
      "won": won,
      "lost": lost,
      "draw": draw,
      "points": points,
      "netRunRate": netRunRate,
      "goalsFor": goalsFor,
      "goalsAgainst": goalsAgainst,
      "goalDifference": goalDifference,
    };
  }
}
