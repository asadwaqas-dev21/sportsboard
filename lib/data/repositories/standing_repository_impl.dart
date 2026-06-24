import "package:cloud_firestore/cloud_firestore.dart";
import "package:sportsboard/app/config/app_constants.dart";
import "package:sportsboard/data/models/standing_model.dart";
import "package:sportsboard/domain/entities/standing.dart";
import "package:sportsboard/domain/repositories/standing_repository.dart";

/// Firestore implementation of StandingRepository.
class StandingRepositoryImpl implements StandingRepository {
  final FirebaseFirestore _firestore;

  StandingRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _collection =>
      _firestore.collection(AppConstants.standingsCollection);

  @override
  Stream<List<Standing>> getStandings(String tournamentId) {
    return _collection
        .where("tournamentId", isEqualTo: tournamentId)
        .orderBy("points", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => StandingModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<void> saveStandings(List<Standing> standings) async {
    final batch = _firestore.batch();
    for (final standing in standings) {
      final model = StandingModel.fromEntity(standing);
      if (standing.id.isEmpty) {
        final docRef = _collection.doc();
        batch.set(docRef, model.toFirestore());
      } else {
        batch.set(_collection.doc(standing.id), model.toFirestore());
      }
    }
    await batch.commit();
  }

  @override
  Future<void> deleteStandings(String tournamentId) async {
    final snapshot = await _collection
        .where("tournamentId", isEqualTo: tournamentId)
        .get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
