import "package:sportsboard/domain/entities/fixture.dart";
import "package:sportsboard/domain/repositories/fixture_repository.dart";

class GetFixturesUseCase {
  final FixtureRepository repository;

  GetFixturesUseCase(this.repository);

  Stream<List<Fixture>> execute({String? tournamentId}) {
    return repository.getFixtures(tournamentId: tournamentId);
  }
}
