import "package:cloud_firestore/cloud_firestore.dart";
import "package:sportsboard/domain/entities/player_stats.dart";

/// Firestore-aware model for PlayerStats entity.
class PlayerStatsModel extends PlayerStats {
  const PlayerStatsModel({
    required super.id,
    required super.tournamentId,
    required super.playerId,
    super.playerName,
    super.teamId,
    super.teamName,
    super.sportType,
    super.runs,
    super.balls,
    super.fours,
    super.sixes,
    super.matches,
    super.wickets,
    super.maidens,
    super.overs,
    super.runsConceded,
    super.catches,
    super.goals,
    super.assists,
    super.cleanSheets,
    super.yellowCards,
    super.redCards,
    super.manOfMatch,
    super.rankingPoints,
  });

  factory PlayerStatsModel.fromEntity(PlayerStats s) {
    return PlayerStatsModel(
      id: s.id,
      tournamentId: s.tournamentId,
      playerId: s.playerId,
      playerName: s.playerName,
      teamId: s.teamId,
      teamName: s.teamName,
      sportType: s.sportType,
      runs: s.runs,
      balls: s.balls,
      fours: s.fours,
      sixes: s.sixes,
      matches: s.matches,
      wickets: s.wickets,
      maidens: s.maidens,
      overs: s.overs,
      runsConceded: s.runsConceded,
      catches: s.catches,
      goals: s.goals,
      assists: s.assists,
      cleanSheets: s.cleanSheets,
      yellowCards: s.yellowCards,
      redCards: s.redCards,
      manOfMatch: s.manOfMatch,
      rankingPoints: s.rankingPoints,
    );
  }

  factory PlayerStatsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return PlayerStatsModel(
      id: doc.id,
      tournamentId: data["tournamentId"] as String? ?? "",
      playerId: data["playerId"] as String? ?? "",
      playerName: data["playerName"] as String? ?? "",
      teamId: data["teamId"] as String? ?? "",
      teamName: data["teamName"] as String? ?? "",
      sportType: data["sportType"] as String? ?? "",
      runs: data["runs"] as int? ?? 0,
      balls: data["balls"] as int? ?? 0,
      fours: data["fours"] as int? ?? 0,
      sixes: data["sixes"] as int? ?? 0,
      matches: data["matches"] as int? ?? 0,
      wickets: data["wickets"] as int? ?? 0,
      maidens: data["maidens"] as int? ?? 0,
      overs: (data["overs"] as num?)?.toDouble() ?? 0.0,
      runsConceded: data["runsConceded"] as int? ?? 0,
      catches: data["catches"] as int? ?? 0,
      goals: data["goals"] as int? ?? 0,
      assists: data["assists"] as int? ?? 0,
      cleanSheets: data["cleanSheets"] as int? ?? 0,
      yellowCards: data["yellowCards"] as int? ?? 0,
      redCards: data["redCards"] as int? ?? 0,
      manOfMatch: data["manOfMatch"] as int? ?? 0,
      rankingPoints: data["rankingPoints"] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "tournamentId": tournamentId,
      "playerId": playerId,
      "playerName": playerName,
      "teamId": teamId,
      "teamName": teamName,
      "sportType": sportType,
      "runs": runs,
      "balls": balls,
      "fours": fours,
      "sixes": sixes,
      "matches": matches,
      "wickets": wickets,
      "maidens": maidens,
      "overs": overs,
      "runsConceded": runsConceded,
      "catches": catches,
      "goals": goals,
      "assists": assists,
      "cleanSheets": cleanSheets,
      "yellowCards": yellowCards,
      "redCards": redCards,
      "manOfMatch": manOfMatch,
      "rankingPoints": rankingPoints,
    };
  }
}
