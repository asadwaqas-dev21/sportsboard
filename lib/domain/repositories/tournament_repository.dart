import "package:sportsboard/domain/entities/tournament.dart";

/// Abstract tournament repository contract.
abstract class TournamentRepository {
  Stream<List<Tournament>> getTournaments({String? sportId});
  Future<Tournament?> getTournamentById(String id);
  Future<void> addTournament(Tournament tournament);
  Future<void> updateTournament(Tournament tournament);
  Future<void> deleteTournament(String id);
}
