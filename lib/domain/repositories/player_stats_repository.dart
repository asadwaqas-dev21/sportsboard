import "package:sportsboard/domain/entities/player_stats.dart";

/// Abstract player stats repository contract.
abstract class PlayerStatsRepository {
  Stream<List<PlayerStats>> getPlayerStats({
    required String tournamentId,
    String? sportType,
  });
  Future<PlayerStats?> getPlayerStatsById(String id);
  Future<void> savePlayerStats(PlayerStats stats);
  Future<void> saveBulkPlayerStats(List<PlayerStats> statsList);
  Future<void> deletePlayerStats(String id);
}
