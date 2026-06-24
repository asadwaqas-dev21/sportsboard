import "package:sportsboard/domain/entities/sport.dart";
import "package:sportsboard/domain/repositories/sport_repository.dart";

class GetSportsUseCase {
  final SportRepository repository;

  GetSportsUseCase(this.repository);

  Stream<List<Sport>> execute() {
    return repository.getSports();
  }
}
