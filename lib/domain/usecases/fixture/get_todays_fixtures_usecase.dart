import "package:sportsboard/domain/entities/fixture.dart";
import "package:sportsboard/domain/repositories/fixture_repository.dart";

class GetTodaysFixturesUseCase {
  final FixtureRepository repository;

  GetTodaysFixturesUseCase(this.repository);

  Stream<List<Fixture>> execute() {
    return repository.getTodaysFixtures();
  }
}
