import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/presentation/global_widgets/app_scaffold.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/global_widgets/match_card.dart";
import "package:sportsboard/presentation/modules/admin_fixtures/controller/admin_fixtures_controller.dart";

class AdminFixturesScreen extends GetView<AdminFixturesController> {
  const AdminFixturesScreen({super.key});

  void _showAddFixtureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Fixture"),
        content: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller.teamANameController,
                decoration: const InputDecoration(labelText: "Team A Name"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.teamBNameController,
                decoration: const InputDecoration(labelText: "Team B Name"),
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
                    onPressed: () => controller.addFixture(),
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
      title: "Manage Fixtures",
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFixtureDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ListLoadingWidget(count: 5, itemHeight: 160);
        }

        if (controller.fixtures.isEmpty) {
          return const Center(child: Text("No fixtures added yet"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.fixtures.length,
          itemBuilder: (context, index) {
            final fixture = controller.fixtures[index];
            return MatchCard(
              fixture: fixture,
              onTap: () {
                // Navigate to edit/result page
              },
            );
          },
        );
      }),
    );
  }
}
