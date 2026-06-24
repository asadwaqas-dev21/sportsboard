import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/app/routes/app_routes.dart";
import "package:sportsboard/domain/entities/tournament.dart";
import "package:sportsboard/presentation/global_widgets/app_scaffold.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/global_widgets/team_tile.dart";
import "package:sportsboard/presentation/modules/team/controller/team_controller.dart";

class TeamsListScreen extends GetView<TeamController> {
  const TeamsListScreen({super.key});

  void _showAddTeamDialog(BuildContext context) {
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
              const SizedBox(height: 16),
              Obx(() {
                if (controller.tournaments.isEmpty) {
                  return const Text(
                    "Please add a Tournament first.",
                    style: TextStyle(color: Colors.red, fontSize: 13),
                  );
                }
                return DropdownButtonFormField<Tournament>(
                  // ignore: deprecated_member_use
                  value: controller.selectedTournament.value,
                  decoration: const InputDecoration(labelText: "Select Tournament"),
                  items: controller.tournaments
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t.name),
                          ))
                      .toList(),
                  onChanged: (val) {
                    controller.selectedTournament.value = val;
                  },
                  validator: (val) => val == null ? "Required" : null,
                );
              }),
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
                    onPressed: () {
                      final selected = controller.selectedTournament.value;
                      if (selected != null) {
                        controller.saveTeam(selected.id);
                      } else {
                        Get.snackbar("Error", "Please select a tournament");
                      }
                    },
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
                  Get.toNamed(AppRoutes.players, arguments: controller.teams[index]);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
