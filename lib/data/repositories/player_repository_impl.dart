import "package:cloud_firestore/cloud_firestore.dart";
import "package:sportsboard/app/config/app_constants.dart";
import "package:sportsboard/data/models/player_model.dart";
import "package:sportsboard/domain/entities/player.dart";
import "package:sportsboard/domain/repositories/player_repository.dart";

/// Firestore implementation of PlayerRepository.
class PlayerRepositoryImpl implements PlayerRepository {
  final FirebaseFirestore _firestore;

  PlayerRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _collection =>
      _firestore.collection(AppConstants.playersCollection);

  @override
  Stream<List<Player>> getPlayers({String? teamId, String? sportId}) {
    Query query = _collection;
    if (teamId != null && teamId.isNotEmpty) {
      query = query.where("teamId", isEqualTo: teamId);
    }
    if (sportId != null && sportId.isNotEmpty) {
      query = query.where("sportId", isEqualTo: sportId);
    }
    return query.snapshots().map(
          (snapshot) {
            final list = snapshot.docs
                .map((doc) => PlayerModel.fromFirestore(doc))
                .toList();
            list.sort((a, b) => a.name.compareTo(b.name));
            return list;
          },
        );
  }

  @override
  Future<Player?> getPlayerById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return PlayerModel.fromFirestore(doc);
  }

  @override
  Future<void> addPlayer(Player player) async {
    final model = PlayerModel.fromEntity(player);
    if (player.id.isEmpty) {
      await _collection.add(model.toFirestore());
    } else {
      await _collection.doc(player.id).set(model.toFirestore());
    }
  }

  @override
  Future<void> updatePlayer(Player player) async {
    final model = PlayerModel.fromEntity(player);
    await _collection.doc(player.id).update(model.toFirestore());
  }

  @override
  Future<void> deletePlayer(String id) async {
    await _collection.doc(id).delete();
  }
}
