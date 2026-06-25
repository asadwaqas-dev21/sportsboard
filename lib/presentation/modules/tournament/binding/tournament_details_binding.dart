import "package:get/get.dart";
import "package:sportsboard/domain/entities/tournament.dart";
import "package:sportsboard/domain/usecases/standing/calculate_standings_usecase.dart";
import "package:sportsboard/presentation/modules/tournament/controller/tournament_details_controller.dart";

class TournamentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final tournament = Get.arguments as Tournament;

    Get.lazyPut(() => CalculateStandingsUseCase(
      resultRepository: Get.find(),
      standingRepository: Get.find(),
      fixtureRepository: Get.find(),
    ));

    Get.put(TournamentDetailsController(
      tournament: tournament,
      teamRepository: Get.find(),
      standingRepository: Get.find(),
      fixtureRepository: Get.find(),
      calculateStandingsUseCase: Get.find(),
      authRepository: Get.find(),
    ));
  }
}
