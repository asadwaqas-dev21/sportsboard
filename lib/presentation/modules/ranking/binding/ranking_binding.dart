import "package:get/get.dart";
import "package:sportsboard/presentation/modules/ranking/controller/ranking_controller.dart";

class RankingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RankingController(playerStatsRepository: Get.find()));
  }
}
