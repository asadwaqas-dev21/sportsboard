import "package:sportsboard/domain/entities/result.dart";

/// Abstract result repository contract.
abstract class ResultRepository {
  Stream<List<Result>> getResults({String? tournamentId, int? limit});
  Stream<List<Result>> getRecentResults({int limit = 10});
  Future<Result?> getResultById(String id);
  Future<Result?> getResultByFixtureId(String fixtureId);
  Future<void> addResult(Result result);
  Future<void> updateResult(Result result);
  Future<void> deleteResult(String id);
}
