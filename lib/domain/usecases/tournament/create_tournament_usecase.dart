import "package:sportsboard/domain/entities/tournament.dart";
import "package:sportsboard/domain/repositories/tournament_repository.dart";

class CreateTournamentUseCase {
  final TournamentRepository repository;

  CreateTournamentUseCase(this.repository);

  Future<void> execute(Tournament tournament) {
    return repository.addTournament(tournament);
  }
}
