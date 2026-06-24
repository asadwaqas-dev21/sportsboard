import "package:cloud_firestore/cloud_firestore.dart";
import "package:sportsboard/app/config/app_constants.dart";
import "package:sportsboard/data/models/player_stats_model.dart";
import "package:sportsboard/domain/entities/player_stats.dart";
import "package:sportsboard/domain/repositories/player_stats_repository.dart";

/// Firestore implementation of PlayerStatsRepository.
class PlayerStatsRepositoryImpl implements PlayerStatsRepository {
  final FirebaseFirestore _firestore;

  PlayerStatsRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _collection =>
      _firestore.collection(AppConstants.playerStatsCollection);

  @override
  Stream<List<PlayerStats>> getPlayerStats({
    required String tournamentId,
    String? sportType,
  }) {
    Query query = _collection
        .where("tournamentId", isEqualTo: tournamentId)
        .orderBy("rankingPoints", descending: true);
    if (sportType != null && sportType.isNotEmpty) {
      query = query.where("sportType", isEqualTo: sportType);
    }
    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => PlayerStatsModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<PlayerStats?> getPlayerStatsById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return PlayerStatsModel.fromFirestore(doc);
  }

  @override
  Future<void> savePlayerStats(PlayerStats stats) async {
    final model = PlayerStatsModel.fromEntity(stats);
    if (stats.id.isEmpty) {
      await _collection.add(model.toFirestore());
    } else {
      await _collection.doc(stats.id).set(model.toFirestore());
    }
  }

  @override
  Future<void> saveBulkPlayerStats(List<PlayerStats> statsList) async {
    final batch = _firestore.batch();
    for (final stats in statsList) {
      final model = PlayerStatsModel.fromEntity(stats);
      if (stats.id.isEmpty) {
        batch.set(_collection.doc(), model.toFirestore());
      } else {
        batch.set(_collection.doc(stats.id), model.toFirestore());
      }
    }
    await batch.commit();
  }

  @override
  Future<void> deletePlayerStats(String id) async {
    await _collection.doc(id).delete();
  }
}
