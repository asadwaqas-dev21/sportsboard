import "package:cloud_firestore/cloud_firestore.dart";
import "package:sportsboard/domain/entities/result.dart";

/// Firestore-aware model for Result entity.
class ResultModel extends Result {
  const ResultModel({
    required super.id,
    required super.fixtureId,
    required super.tournamentId,
    super.sportType,
    super.winnerTeamId,
    super.loserTeamId,
    super.teamAName,
    super.teamBName,
    super.scoreSummary,
    super.resultText,
    super.addedBy,
    super.createdAt,
    super.cricketData,
    super.footballData,
    super.indoorData,
  });

  factory ResultModel.fromEntity(Result r) {
    return ResultModel(
      id: r.id,
      fixtureId: r.fixtureId,
      tournamentId: r.tournamentId,
      sportType: r.sportType,
      winnerTeamId: r.winnerTeamId,
      loserTeamId: r.loserTeamId,
      teamAName: r.teamAName,
      teamBName: r.teamBName,
      scoreSummary: r.scoreSummary,
      resultText: r.resultText,
      addedBy: r.addedBy,
      createdAt: r.createdAt,
      cricketData: r.cricketData,
      footballData: r.footballData,
      indoorData: r.indoorData,
    );
  }

  factory ResultModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ResultModel(
      id: doc.id,
      fixtureId: data["fixtureId"] as String? ?? "",
      tournamentId: data["tournamentId"] as String? ?? "",
      sportType: data["sportType"] as String? ?? "",
      winnerTeamId: data["winnerTeamId"] as String? ?? "",
      loserTeamId: data["loserTeamId"] as String? ?? "",
      teamAName: data["teamAName"] as String? ?? "",
      teamBName: data["teamBName"] as String? ?? "",
      scoreSummary: data["scoreSummary"] as String? ?? "",
      resultText: data["resultText"] as String? ?? "",
      addedBy: data["addedBy"] as String? ?? "",
      createdAt: (data["createdAt"] as Timestamp?)?.toDate(),
      cricketData: data["cricketData"] as Map<String, dynamic>?,
      footballData: data["footballData"] as Map<String, dynamic>?,
      indoorData: data["indoorData"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "fixtureId": fixtureId,
      "tournamentId": tournamentId,
      "sportType": sportType,
      "winnerTeamId": winnerTeamId,
      "loserTeamId": loserTeamId,
      "teamAName": teamAName,
      "teamBName": teamBName,
      "scoreSummary": scoreSummary,
      "resultText": resultText,
      "addedBy": addedBy,
      "createdAt": FieldValue.serverTimestamp(),
      if (cricketData != null) "cricketData": cricketData,
      if (footballData != null) "footballData": footballData,
      if (indoorData != null) "indoorData": indoorData,
    };
  }
}
