import "package:sportsboard/domain/entities/tournament.dart";
import "package:sportsboard/domain/repositories/tournament_repository.dart";

class GetTournamentsUseCase {
  final TournamentRepository repository;

  GetTournamentsUseCase(this.repository);

  Stream<List<Tournament>> execute({String? sportId}) {
    return repository.getTournaments(sportId: sportId);
  }
}
