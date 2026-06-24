import "package:get/get.dart";
import "package:sportsboard/domain/usecases/auth/login_usecase.dart";
import "package:sportsboard/presentation/modules/auth/controller/auth_controller.dart";

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginUseCase(Get.find()));
    Get.put(AuthController(loginUseCase: Get.find()));
  }
}
