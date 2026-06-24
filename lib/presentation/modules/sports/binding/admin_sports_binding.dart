import "package:get/get.dart";
import "package:sportsboard/presentation/modules/sports/controller/admin_sports_controller.dart";
import "package:sportsboard/domain/usecases/sport/get_sports_usecase.dart";
import "package:sportsboard/domain/usecases/sport/create_sport_usecase.dart";

class AdminSportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetSportsUseCase(Get.find()));
    Get.lazyPut(() => CreateSportUseCase(Get.find()));

    Get.put(AdminSportsController(
      getSportsUseCase: Get.find(),
      createSportUseCase: Get.find(),
    ));
  }
}
