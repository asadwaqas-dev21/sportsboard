import "package:get/get.dart";
import "package:sportsboard/presentation/modules/standing/controller/standing_controller.dart";

class StandingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StandingController(standingRepository: Get.find()));
  }
}
