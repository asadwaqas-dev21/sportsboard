import "package:cloud_firestore/cloud_firestore.dart";
import "package:sportsboard/app/config/app_constants.dart";
import "package:sportsboard/data/models/tournament_model.dart";
import "package:sportsboard/domain/entities/tournament.dart";
import "package:sportsboard/domain/repositories/tournament_repository.dart";

/// Firestore implementation of TournamentRepository.
class TournamentRepositoryImpl implements TournamentRepository {
  final FirebaseFirestore _firestore;

  TournamentRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _collection =>
      _firestore.collection(AppConstants.tournamentsCollection);

  @override
  Stream<List<Tournament>> getTournaments({String? sportId}) {
    Query query = _collection.orderBy("name");
    if (sportId != null && sportId.isNotEmpty) {
      query = query.where("sportId", isEqualTo: sportId);
    }
    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => TournamentModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<Tournament?> getTournamentById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return TournamentModel.fromFirestore(doc);
  }

  @override
  Future<void> addTournament(Tournament tournament) async {
    final model = TournamentModel.fromEntity(tournament);
    if (tournament.id.isEmpty) {
      await _collection.add(model.toFirestore());
    } else {
      await _collection.doc(tournament.id).set(model.toFirestore());
    }
  }

  @override
  Future<void> updateTournament(Tournament tournament) async {
    final model = TournamentModel.fromEntity(tournament);
    await _collection.doc(tournament.id).update(model.toFirestore());
  }

  @override
  Future<void> deleteTournament(String id) async {
    await _collection.doc(id).delete();
  }
}
