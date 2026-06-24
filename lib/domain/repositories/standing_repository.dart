import "package:sportsboard/domain/entities/standing.dart";

/// Abstract standing repository contract.
abstract class StandingRepository {
  Stream<List<Standing>> getStandings(String tournamentId);
  Future<void> saveStandings(List<Standing> standings);
  Future<void> deleteStandings(String tournamentId);
}
