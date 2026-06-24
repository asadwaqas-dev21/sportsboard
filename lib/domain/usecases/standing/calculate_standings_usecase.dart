import "package:sportsboard/app/config/app_constants.dart";
import "package:sportsboard/core/enums/sport_type.dart";
import "package:sportsboard/domain/entities/result.dart";
import "package:sportsboard/domain/entities/standing.dart";
import "package:sportsboard/domain/entities/team.dart";
import "package:sportsboard/domain/repositories/result_repository.dart";
import "package:sportsboard/domain/repositories/standing_repository.dart";

class CalculateStandingsUseCase {
  final ResultRepository resultRepository;
  final StandingRepository standingRepository;

  CalculateStandingsUseCase({
    required this.resultRepository,
    required this.standingRepository,
  });

  /// Calculates standings for a tournament based on sport type and saves them.
  Future<void> execute(
    String tournamentId,
    String sportTypeStr,
    List<Team> teams,
  ) async {
    final sportType = SportType.fromKey(sportTypeStr);

    // 1. Get all results for this tournament
    final resultsStream = resultRepository.getResults(tournamentId: tournamentId);
    final resultsList = await resultsStream.first;

    // 2. Initialize standing map
    final Map<String, Standing> standingsMap = {};
    for (var team in teams) {
      standingsMap[team.id] = Standing(
        id: "", // Will be assigned by repo if new, but we need to fetch existing if possible. Let's just regenerate and overwrite for simplicity in this bulk update.
        tournamentId: tournamentId,
        teamId: team.id,
        teamName: team.name,
      );
    }

    // 3. Process each result
    for (var result in resultsList) {
      if (sportType.isCricket) {
        _processCricketResult(result, standingsMap);
      } else if (sportType.isFootball) {
        _processFootballResult(result, standingsMap);
      }
      // Add other sports logic here
    }

    // 4. Save to repository (overwrite existing)
    // First, get existing standings to keep IDs
    final existingStandingsStream = standingRepository.getStandings(tournamentId);
    final existingStandings = await existingStandingsStream.first;
    final Map<String, String> existingIds = {
      for (var s in existingStandings) s.teamId: s.id
    };

    final List<Standing> finalStandings = standingsMap.values.map((s) {
      return s.copyWith(id: existingIds[s.teamId] ?? "");
    }).toList();

    await standingRepository.saveStandings(finalStandings);
  }

  void _processCricketResult(Result result, Map<String, Standing> standings) {
    // Basic W/L/D calculation for cricket
    final winnerId = result.winnerTeamId;
    final loserId = result.loserTeamId;
    
    // Handle No Result/Draw (assuming winnerTeamId is empty for draw)
    if (winnerId.isEmpty && result.teamAName.isNotEmpty && result.teamBName.isNotEmpty) {
      // It's a draw/no result, need to figure out team IDs from somewhere
      // In a real app, Result entity should have teamAId and teamBId
      // For now, this is a simplified calculation.
      return; 
    }

    if (standings.containsKey(winnerId)) {
      final w = standings[winnerId]!;
      standings[winnerId] = w.copyWith(
        played: w.played + 1,
        won: w.won + 1,
        points: w.points + AppConstants.cricketWinPoints,
      );
    }

    if (loserId.isNotEmpty && standings.containsKey(loserId)) {
      final l = standings[loserId]!;
      standings[loserId] = l.copyWith(
        played: l.played + 1,
        lost: l.lost + 1,
        points: l.points + AppConstants.cricketLossPoints,
      );
    }
  }

  void _processFootballResult(Result result, Map<String, Standing> standings) {
    // This is a simplified calculation. 
    // In a full implementation, Result should contain teamAId, teamBId, teamAGoals, teamBGoals
    // For now, it just calculates basic wins/losses based on winnerId.
    final winnerId = result.winnerTeamId;
    final loserId = result.loserTeamId;

    if (standings.containsKey(winnerId)) {
      final w = standings[winnerId]!;
      standings[winnerId] = w.copyWith(
        played: w.played + 1,
        won: w.won + 1,
        points: w.points + AppConstants.footballWinPoints,
      );
    }

    if (loserId.isNotEmpty && standings.containsKey(loserId)) {
      final l = standings[loserId]!;
      standings[loserId] = l.copyWith(
        played: l.played + 1,
        lost: l.lost + 1,
        points: l.points + AppConstants.footballLossPoints,
      );
    }
  }
}
