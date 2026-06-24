import "package:cloud_firestore/cloud_firestore.dart";
import "package:sportsboard/app/config/app_constants.dart";
import "package:sportsboard/data/models/result_model.dart";
import "package:sportsboard/domain/entities/result.dart";
import "package:sportsboard/domain/repositories/result_repository.dart";

/// Firestore implementation of ResultRepository.
class ResultRepositoryImpl implements ResultRepository {
  final FirebaseFirestore _firestore;

  ResultRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _collection =>
      _firestore.collection(AppConstants.resultsCollection);

  @override
  Stream<List<Result>> getResults({String? tournamentId, int? limit}) {
    Query query = _collection.orderBy("createdAt", descending: true);
    if (tournamentId != null && tournamentId.isNotEmpty) {
      query = query.where("tournamentId", isEqualTo: tournamentId);
    }
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => ResultModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Stream<List<Result>> getRecentResults({int limit = 10}) {
    return _collection
        .orderBy("createdAt", descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ResultModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<Result?> getResultById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return ResultModel.fromFirestore(doc);
  }

  @override
  Future<Result?> getResultByFixtureId(String fixtureId) async {
    final snapshot = await _collection
        .where("fixtureId", isEqualTo: fixtureId)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return ResultModel.fromFirestore(snapshot.docs.first);
  }

  @override
  Future<void> addResult(Result result) async {
    final model = ResultModel.fromEntity(result);
    if (result.id.isEmpty) {
      await _collection.add(model.toFirestore());
    } else {
      await _collection.doc(result.id).set(model.toFirestore());
    }
  }

  @override
  Future<void> updateResult(Result result) async {
    final model = ResultModel.fromEntity(result);
    await _collection.doc(result.id).update(model.toFirestore());
  }

  @override
  Future<void> deleteResult(String id) async {
    await _collection.doc(id).delete();
  }
}
