import "package:sportsboard/domain/entities/fixture.dart";
import "package:sportsboard/domain/repositories/fixture_repository.dart";

class CreateFixtureUseCase {
  final FixtureRepository repository;

  CreateFixtureUseCase(this.repository);

  Future<void> execute(Fixture fixture) {
    return repository.addFixture(fixture);
  }
}
