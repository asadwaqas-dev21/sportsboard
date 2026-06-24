import "package:sportsboard/domain/entities/fixture.dart";

/// Abstract fixture repository contract.
abstract class FixtureRepository {
  Stream<List<Fixture>> getFixtures({String? tournamentId});
  Stream<List<Fixture>> getTodaysFixtures();
  Future<Fixture?> getFixtureById(String id);
  Future<void> addFixture(Fixture fixture);
  Future<void> updateFixture(Fixture fixture);
  Future<void> deleteFixture(String id);
}
