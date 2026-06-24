import "package:cloud_firestore/cloud_firestore.dart";
import "package:sportsboard/app/config/app_constants.dart";
import "package:sportsboard/data/models/team_model.dart";
import "package:sportsboard/domain/entities/team.dart";
import "package:sportsboard/domain/repositories/team_repository.dart";

/// Firestore implementation of TeamRepository.
class TeamRepositoryImpl implements TeamRepository {
  final FirebaseFirestore _firestore;

  TeamRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _collection =>
      _firestore.collection(AppConstants.teamsCollection);

  @override
  Stream<List<Team>> getTeams({String? tournamentId}) {
    Query query = _collection.orderBy("name");
    if (tournamentId != null && tournamentId.isNotEmpty) {
      query = query.where("tournamentId", isEqualTo: tournamentId);
    }
    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => TeamModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<Team?> getTeamById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return TeamModel.fromFirestore(doc);
  }

  @override
  Future<void> addTeam(Team team) async {
    final model = TeamModel.fromEntity(team);
    if (team.id.isEmpty) {
      await _collection.add(model.toFirestore());
    } else {
      await _collection.doc(team.id).set(model.toFirestore());
    }
  }

  @override
  Future<void> updateTeam(Team team) async {
    final model = TeamModel.fromEntity(team);
    await _collection.doc(team.id).update(model.toFirestore());
  }

  @override
  Future<void> deleteTeam(String id) async {
    await _collection.doc(id).delete();
  }
}
