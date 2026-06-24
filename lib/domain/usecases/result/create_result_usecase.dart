import "package:sportsboard/domain/entities/result.dart";
import "package:sportsboard/domain/repositories/result_repository.dart";

class CreateResultUseCase {
  final ResultRepository repository;

  CreateResultUseCase(this.repository);

  Future<void> execute(Result result) {
    return repository.addResult(result);
  }
}
