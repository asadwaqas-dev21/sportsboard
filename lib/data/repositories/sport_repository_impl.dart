import "package:cloud_firestore/cloud_firestore.dart";
import "package:sportsboard/app/config/app_constants.dart";
import "package:sportsboard/data/models/sport_model.dart";
import "package:sportsboard/domain/entities/sport.dart";
import "package:sportsboard/domain/repositories/sport_repository.dart";

/// Firestore implementation of SportRepository.
class SportRepositoryImpl implements SportRepository {
  final FirebaseFirestore _firestore;

  SportRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _collection =>
      _firestore.collection(AppConstants.sportsCollection);

  @override
  Stream<List<Sport>> getSports() {
    return _collection.orderBy("order").snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => SportModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<Sport?> getSportById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return SportModel.fromFirestore(doc);
  }

  @override
  Future<void> addSport(Sport sport) async {
    final model = SportModel.fromEntity(sport);
    if (sport.id.isEmpty) {
      await _collection.add(model.toFirestore());
    } else {
      await _collection.doc(sport.id).set(model.toFirestore());
    }
  }

  @override
  Future<void> updateSport(Sport sport) async {
    final model = SportModel.fromEntity(sport);
    await _collection.doc(sport.id).update(model.toFirestore());
  }

  @override
  Future<void> deleteSport(String id) async {
    await _collection.doc(id).delete();
  }
}
