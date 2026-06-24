import "package:flutter/material.dart";
import "package:iconsax/iconsax.dart";
import "package:sportsboard/core/theme/app_colors.dart";
import "package:sportsboard/core/utils/validators.dart";
import "package:sportsboard/presentation/global_widgets/gradient_button.dart";
import "package:sportsboard/presentation/modules/auth/controller/auth_controller.dart";
import "package:get/get.dart";

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: controller.loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo/Header
                  Icon(
                    Icons.admin_panel_settings,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Admin Login",
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sign in to manage sports",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Form Fields
                  TextFormField(
                    controller: controller.emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Iconsax.sms),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => TextFormField(
                      controller: controller.passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Iconsax.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscurePassword.value
                                ? Iconsax.eye_slash
                                : Iconsax.eye,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                      obscureText: controller.obscurePassword.value,
                      validator: Validators.password,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Login Button
                  Obx(
                    () => GradientButton(
                      text: "Login",
                      isLoading: controller.isLoading.value,
                      onPressed: controller.login,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
