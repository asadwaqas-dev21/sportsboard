import "package:get/get.dart";
// Wait, I need a general get fixtures usecase
import "package:sportsboard/domain/usecases/fixture/create_fixture_usecase.dart";
import "package:sportsboard/presentation/modules/admin_fixtures/controller/admin_fixtures_controller.dart";

class AdminFixturesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateFixtureUseCase(Get.find()));
    
    Get.put(AdminFixturesController(
      fixtureRepository: Get.find(),
      createFixtureUseCase: Get.find(),
    ));
  }
}
