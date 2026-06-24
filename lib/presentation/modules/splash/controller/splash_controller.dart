import "package:get/get.dart";
import "package:sportsboard/app/routes/app_routes.dart";
import "package:sportsboard/domain/repositories/auth_repository.dart";

class SplashController extends GetxController {
  final AuthRepository authRepository;

  SplashController({required this.authRepository});

  @override
  void onReady() {
    super.onReady();
    _checkAuth();
  }

  void _checkAuth() async {
    // Artificial delay for splash animation
    await Future.delayed(const Duration(seconds: 2));

    if (authRepository.isLoggedIn) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
