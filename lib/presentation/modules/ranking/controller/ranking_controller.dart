import "dart:async";
import "package:get/get.dart";
import "package:sportsboard/domain/entities/player_stats.dart";
import "package:sportsboard/domain/repositories/player_stats_repository.dart";
import "package:sportsboard/core/enums/sport_type.dart";

class RankingController extends GetxController {
  final PlayerStatsRepository playerStatsRepository;

  RankingController({required this.playerStatsRepository});

  final RxList<PlayerStats> rankings = <PlayerStats>[].obs;
  final RxBool isLoading = true.obs;
  StreamSubscription? _rankingsSub;

  @override
  void onClose() {
    _rankingsSub?.cancel();
    super.onClose();
  }

  void loadRankings(String tournamentId, String sportTypeStr) {
    isLoading.value = true;
    _rankingsSub?.cancel();
    _rankingsSub = playerStatsRepository
        .getPlayerStats(tournamentId: tournamentId, sportType: sportTypeStr)
        .listen((data) {
      rankings.value = data;
      isLoading.value = false;
    });
  }

  String getPrimaryStatLabel(String sportTypeStr) {
    final sportType = SportType.fromKey(sportTypeStr);
    if (sportType.isCricket) return "Runs/Wickets"; // Simplified, can add filters later
    if (sportType.isFootball) return "Goals";
    return "Points";
  }

  String getPrimaryStatValue(PlayerStats stats, String sportTypeStr) {
    final sportType = SportType.fromKey(sportTypeStr);
    if (sportType.isCricket) return "${stats.runs} R / ${stats.wickets} W";
    if (sportType.isFootball) return "${stats.goals}";
    return "${stats.rankingPoints}";
  }
}
