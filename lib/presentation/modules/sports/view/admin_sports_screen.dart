import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/presentation/global_widgets/app_scaffold.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/global_widgets/sport_card.dart";
import "package:sportsboard/presentation/modules/sports/controller/admin_sports_controller.dart";

class AdminSportsScreen extends GetView<AdminSportsController> {
  const AdminSportsScreen({super.key});

  void _showAddSportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Sport"),
        content: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(labelText: "Sport Name (e.g., Football 2026)"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.typeController,
                decoration: const InputDecoration(labelText: "Type key (e.g., cricket, football)"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          Obx(
            () => controller.isSaving.value
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () => controller.addSport(),
                    child: const Text("Add"),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Manage Sports",
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSportDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 4,
            itemBuilder: (context, index) => const LoadingWidget(),
          );
        }

        if (controller.sports.isEmpty) {
          return const Center(child: Text("No sports added yet"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: controller.sports.length,
          itemBuilder: (context, index) {
            return SportCard(
              sport: controller.sports[index],
              onTap: () {
                // Future edit feature
              },
            );
          },
        );
      }),
    );
  }
}
