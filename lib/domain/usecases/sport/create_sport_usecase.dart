import "package:sportsboard/domain/entities/sport.dart";
import "package:sportsboard/domain/repositories/sport_repository.dart";

class CreateSportUseCase {
  final SportRepository repository;

  CreateSportUseCase(this.repository);

  Future<void> execute(Sport sport) {
    return repository.addSport(sport);
  }
}
