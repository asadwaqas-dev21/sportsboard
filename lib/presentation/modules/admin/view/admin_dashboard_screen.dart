import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:sportsboard/presentation/global_widgets/app_scaffold.dart";
import "package:sportsboard/presentation/modules/admin/controller/admin_controller.dart";
import "package:sportsboard/app/routes/app_routes.dart";

class AdminDashboardScreen extends GetView<AdminController> {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Admin Dashboard",
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildAdminCard(
            context,
            title: "Tournaments",
            icon: Iconsax.cup,
            onTap: () => Get.toNamed(AppRoutes.tournaments),
          ),
          _buildAdminCard(
            context,
            title: "Teams",
            icon: Iconsax.people,
            onTap: () => Get.toNamed(AppRoutes.teams),
          ),
          _buildAdminCard(
            context,
            title: "Players",
            icon: Iconsax.user,
            onTap: () => Get.toNamed(AppRoutes.players),
          ),
          _buildAdminCard(
            context,
            title: "Fixtures",
            icon: Iconsax.calendar_1,
            onTap: () => Get.toNamed(AppRoutes.fixtures),
          ),
          _buildAdminCard(
            context,
            title: "Results",
            icon: Iconsax.clipboard_text,
            onTap: () => Get.toNamed(AppRoutes.results),
          ),
          _buildAdminCard(
            context,
            title: "Sports",
            icon: Iconsax.category,
            onTap: () => Get.toNamed(AppRoutes.sports),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
