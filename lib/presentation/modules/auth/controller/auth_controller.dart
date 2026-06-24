import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/app/routes/app_routes.dart";
import "package:sportsboard/core/utils/snackbar_utils.dart";
import "package:sportsboard/domain/usecases/auth/login_usecase.dart";

class AuthController extends GetxController {
  final LoginUseCase loginUseCase;

  AuthController({required this.loginUseCase});

  final loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await loginUseCase.execute(
        emailController.text,
        passwordController.text,
      );
      SnackbarUtils.showSuccess("Logged in successfully");
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
