import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/core/theme/app_colors.dart";

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final bool isDestructive;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDestructive ? AppColors.error : AppColors.primary,
          ),
          child: const Text("Confirm"),
        ),
      ],
    );
  }

  static Future<void> show({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) {
    return Get.dialog(
      ConfirmDialog(
        title: title,
        message: message,
        onConfirm: onConfirm,
        isDestructive: isDestructive,
      ),
    );
  }
}
