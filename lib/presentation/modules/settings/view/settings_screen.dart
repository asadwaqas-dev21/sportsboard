import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:sportsboard/app/routes/app_routes.dart";
import "package:sportsboard/core/theme/theme_controller.dart";
import "package:sportsboard/domain/repositories/auth_repository.dart";
import "package:sportsboard/presentation/global_widgets/confirm_dialog.dart";

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = Get.find<AuthRepository>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(children: [_buildMenuOptions(context, authRepository)]),
      ),
    );
  }

  Widget _buildMenuOptions(
    BuildContext context,
    AuthRepository authRepository,
  ) {
    final themeController = Get.find<ThemeController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildSectionTitle("App Settings"),
          _buildMenuItem(
            context,
            icon: Iconsax.setting_2,
            label: "Theme Settings",
            subtitle: themeController.isDarkMode ? "Dark" : "Light",
            onTap: () => themeController.toggleTheme(),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle("Information"),
          _buildMenuItem(
            context,
            icon: Iconsax.info_circle,
            label: "About UniSports",
            onTap: () {},
          ),
          _buildMenuItem(
            context,
            icon: Iconsax.message_question,
            label: "Help & Support",
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _buildSectionTitle("Administration"),
          if (authRepository.isLoggedIn) ...[
            _buildMenuItem(
              context,
              icon: Iconsax.category,
              label: "Admin Dashboard",
              onTap: () => Get.toNamed(AppRoutes.adminDashboard),
            ),
            _buildMenuItem(
              context,
              icon: Iconsax.logout,
              label: "Logout",
              isDestructive: true,
              onTap: () {
                ConfirmDialog.show(
                  title: "Logout",
                  message: "Are you sure you want to logout?",
                  isDestructive: true,
                  onConfirm: () async {
                    await authRepository.logout();
                    Get.offAllNamed(AppRoutes.splash);
                  },
                );
              },
            ),
          ] else
            _buildMenuItem(
              context,
              icon: Iconsax.login,
              label: "Admin Login",
              onTap: () => Get.toNamed(AppRoutes.login),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? subtitle,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    final color = isDestructive
        ? Colors.red
        : Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: Icon(icon, color: color, size: 24),
          title: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (subtitle != null) ...[
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(width: 8),
              ],
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
