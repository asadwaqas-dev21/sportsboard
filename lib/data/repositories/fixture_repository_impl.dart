import "package:cloud_firestore/cloud_firestore.dart";
import "package:sportsboard/app/config/app_constants.dart";
import "package:sportsboard/data/models/fixture_model.dart";
import "package:sportsboard/domain/entities/fixture.dart";
import "package:sportsboard/domain/repositories/fixture_repository.dart";

/// Firestore implementation of FixtureRepository.
class FixtureRepositoryImpl implements FixtureRepository {
  final FirebaseFirestore _firestore;

  FixtureRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _collection =>
      _firestore.collection(AppConstants.fixturesCollection);

  @override
  Stream<List<Fixture>> getFixtures({String? tournamentId}) {
    Query query = _collection;
    if (tournamentId != null && tournamentId.isNotEmpty) {
      query = query.where("tournamentId", isEqualTo: tournamentId);
    }
    return query.snapshots().map(
          (snapshot) {
            final list = snapshot.docs
                .map((doc) => FixtureModel.fromFirestore(doc))
                .toList();
            list.sort((a, b) {
              if (a.date == null && b.date == null) return 0;
              if (a.date == null) return 1;
              if (b.date == null) return -1;
              return b.date!.compareTo(a.date!);
            });
            return list;
          },
        );
  }

  @override
  Stream<List<Fixture>> getTodaysFixtures() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _collection
        .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where("date", isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy("date")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FixtureModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<Fixture?> getFixtureById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return FixtureModel.fromFirestore(doc);
  }

  @override
  Future<void> addFixture(Fixture fixture) async {
    final model = FixtureModel.fromEntity(fixture);
    if (fixture.id.isEmpty) {
      await _collection.add(model.toFirestore());
    } else {
      await _collection.doc(fixture.id).set(model.toFirestore());
    }
  }

  @override
  Future<void> updateFixture(Fixture fixture) async {
    final model = FixtureModel.fromEntity(fixture);
    await _collection.doc(fixture.id).update(model.toFirestore());
  }

  @override
  Future<void> deleteFixture(String id) async {
    await _collection.doc(id).delete();
  }
}
