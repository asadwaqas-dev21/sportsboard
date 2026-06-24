import "package:sportsboard/app/config/app_constants.dart";
import "package:sportsboard/core/enums/sport_type.dart";
import "package:sportsboard/domain/entities/player_stats.dart";
import "package:sportsboard/domain/repositories/player_stats_repository.dart";

class CalculateRankingsUseCase {
  final PlayerStatsRepository playerStatsRepository;

  CalculateRankingsUseCase({required this.playerStatsRepository});

  Future<void> execute(String tournamentId, String sportTypeStr) async {
    final sportType = SportType.fromKey(sportTypeStr);

    final statsStream = playerStatsRepository.getPlayerStats(
        tournamentId: tournamentId, sportType: sportTypeStr);
    final statsList = await statsStream.first;

    final List<PlayerStats> updatedStats = [];

    for (var stats in statsList) {
      int rankingPoints = 0;

      if (sportType.isCricket) {
        rankingPoints = _calculateCricketPoints(stats);
      } else if (sportType.isFootball) {
        rankingPoints = _calculateFootballPoints(stats);
      }
      
      updatedStats.add(stats.copyWith(rankingPoints: rankingPoints));
    }

    await playerStatsRepository.saveBulkPlayerStats(updatedStats);
  }

  int _calculateCricketPoints(PlayerStats stats) {
    int points = 0;

    // Batting Points
    points += stats.runs * AppConstants.runsPerPoint;
    points += stats.fours * AppConstants.fourBonus;
    points += stats.sixes * AppConstants.sixBonus;
    
    // Milestones per match (approximation since we only have aggregates)
    // In a real scenario, this needs to be calculated per match result and aggregated
    if (stats.runs >= 100) {
        points += AppConstants.centuryBonus; 
    } else if (stats.runs >= 50) {
        points += AppConstants.fiftyBonus;
    }

    // Bowling Points
    points += stats.wickets * AppConstants.wicketPoints;
    points += stats.maidens * AppConstants.maidenPoints;
    
    // Milestones (approximation)
    if (stats.wickets >= 5) {
        points += AppConstants.fiveWicketBonus;
    } else if (stats.wickets >= 3) {
        points += AppConstants.threeWicketBonus;
    }

    return points;
  }

  int _calculateFootballPoints(PlayerStats stats) {
    int points = 0;
    points += stats.goals * AppConstants.goalPoints;
    points += stats.assists * AppConstants.assistPoints;
    points += stats.cleanSheets * AppConstants.cleanSheetPoints;
    points += stats.manOfMatch * AppConstants.manOfMatchPoints;
    points += stats.yellowCards * AppConstants.yellowCardPenalty;
    points += stats.redCards * AppConstants.redCardPenalty;
    return points;
  }
}
