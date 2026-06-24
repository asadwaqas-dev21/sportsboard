import "package:get/get.dart";
import "package:sportsboard/presentation/modules/team/controller/team_controller.dart";
// import usecases when created

class TeamBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TeamController(teamRepository: Get.find()));
  }
}
