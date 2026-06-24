import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:sportsboard/core/theme/app_colors.dart";

/// Utility class for showing styled snackbars.
abstract class SnackbarUtils {
  static void showSuccess(String message) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.rawSnackbar(
      message: message,
      backgroundColor: AppColors.success,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Iconsax.tick_circle, color: Colors.white),
      duration: const Duration(seconds: 2),
      snackStyle: SnackStyle.FLOATING,
      isDismissible: false,
    );
  }

  static void showError(String message) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.rawSnackbar(
      message: message,
      backgroundColor: AppColors.error,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Iconsax.close_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      isDismissible: false,
    );
  }

  static void showWarning(String message) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.rawSnackbar(
      message: message,
      backgroundColor: AppColors.warning,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Iconsax.warning_2, color: Colors.white),
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      isDismissible: false,
    );
  }

  static void showInfo(String message) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.rawSnackbar(
      message: message,
      backgroundColor: AppColors.info,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Iconsax.info_circle, color: Colors.white),
      duration: const Duration(seconds: 2),
      snackStyle: SnackStyle.FLOATING,
      isDismissible: false,
    );
  }
}
