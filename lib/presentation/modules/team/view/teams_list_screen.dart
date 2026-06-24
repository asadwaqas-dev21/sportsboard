import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/presentation/global_widgets/app_scaffold.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/global_widgets/team_tile.dart";
import "package:sportsboard/presentation/modules/team/controller/team_controller.dart";

class TeamsListScreen extends GetView<TeamController> {
  const TeamsListScreen({super.key});

  void _showAddTeamDialog(BuildContext context) {
    final tournamentId = "demo_tournament_id"; // Placeholder

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Team"),
        content: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(labelText: "Team Name"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.captainNameController,
                decoration: const InputDecoration(labelText: "Captain Name"),
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
                    onPressed: () => controller.saveTeam(tournamentId),
                    child: const Text("Add"),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Assuming tournament ID is passed or available
    
    return AppScaffold(
      title: "Teams",
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTeamDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ListLoadingWidget();
        }

        if (controller.teams.isEmpty) {
          return const Center(child: Text("No teams added yet"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.teams.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: TeamTile(
                team: controller.teams[index],
                onTap: () {
                  // View players
                },
              ),
            );
          },
        );
      }),
    );
  }
}
