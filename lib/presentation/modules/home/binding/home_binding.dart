import "package:get/get.dart";
import "package:sportsboard/presentation/modules/home/controller/home_controller.dart";
import "package:sportsboard/domain/usecases/sport/get_sports_usecase.dart";
import "package:sportsboard/domain/usecases/fixture/get_todays_fixtures_usecase.dart";
import "package:sportsboard/domain/usecases/result/get_results_usecase.dart";
import "package:sportsboard/domain/usecases/result/create_result_usecase.dart";
import "package:sportsboard/domain/usecases/standing/calculate_standings_usecase.dart";
import "package:sportsboard/presentation/modules/result/controller/result_controller.dart";

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetSportsUseCase(Get.find()));
    Get.lazyPut(() => GetTodaysFixturesUseCase(Get.find()));
    Get.lazyPut(() => GetResultsUseCase(Get.find()));
    Get.lazyPut(() => CreateResultUseCase(Get.find()));
    Get.lazyPut(
      () => CalculateStandingsUseCase(
        resultRepository: Get.find(),
        standingRepository: Get.find(),
        fixtureRepository: Get.find(),
      ),
    );

    Get.put(
      ResultController(
        getResultsUseCase: Get.find(),
        createResultUseCase: Get.find(),
        calculateStandingsUseCase: Get.find(),
        fixtureRepository: Get.find(),
        teamRepository: Get.find(),
      ),
    );

    Get.put(
      HomeController(
        getSportsUseCase: Get.find(),
        getTodaysFixturesUseCase: Get.find(),
        getResultsUseCase: Get.find(),
      ),
    );
  }
}
