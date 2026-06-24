import "package:get/get.dart";
import "package:sportsboard/presentation/modules/player/controller/player_controller.dart";

class PlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PlayerController(playerRepository: Get.find()));
  }
}
