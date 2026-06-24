import "package:sportsboard/domain/entities/player.dart";

/// Abstract player repository contract.
abstract class PlayerRepository {
  Stream<List<Player>> getPlayers({String? teamId, String? sportId});
  Future<Player?> getPlayerById(String id);
  Future<void> addPlayer(Player player);
  Future<void> updatePlayer(Player player);
  Future<void> deletePlayer(String id);
}
