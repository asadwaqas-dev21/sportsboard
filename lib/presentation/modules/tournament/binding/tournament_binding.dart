import "package:get/get.dart";
import "package:sportsboard/domain/usecases/tournament/get_tournaments_usecase.dart";
import "package:sportsboard/domain/usecases/tournament/create_tournament_usecase.dart";
import "package:sportsboard/presentation/modules/tournament/controller/tournament_controller.dart";

class TournamentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetTournamentsUseCase(Get.find()));
    Get.lazyPut(() => CreateTournamentUseCase(Get.find()));
    
    Get.put(TournamentController(
      getTournamentsUseCase: Get.find(),
      createTournamentUseCase: Get.find(),
    ));
  }
}
