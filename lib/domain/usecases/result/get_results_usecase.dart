import "package:sportsboard/domain/entities/result.dart";
import "package:sportsboard/domain/repositories/result_repository.dart";

class GetResultsUseCase {
  final ResultRepository repository;

  GetResultsUseCase(this.repository);

  Stream<List<Result>> execute({String? tournamentId, int? limit}) {
    return repository.getResults(tournamentId: tournamentId, limit: limit);
  }
}
