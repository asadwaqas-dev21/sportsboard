import "package:sportsboard/domain/entities/team.dart";

/// Abstract team repository contract.
abstract class TeamRepository {
  Stream<List<Team>> getTeams({String? tournamentId});
  Future<Team?> getTeamById(String id);
  Future<void> addTeam(Team team);
  Future<void> updateTeam(Team team);
  Future<void> deleteTeam(String id);
}
