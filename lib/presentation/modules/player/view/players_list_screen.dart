import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/presentation/global_widgets/app_scaffold.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/global_widgets/player_tile.dart";
import "package:sportsboard/presentation/modules/player/controller/player_controller.dart";

class PlayersListScreen extends GetView<PlayerController> {
  const PlayersListScreen({super.key});

  void _showAddPlayerDialog(BuildContext context) {
    final teamId = "demo_team_id"; // Placeholder
    final teamName = "Demo Team";
    final sportId = "football_id";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Player"),
        content: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(labelText: "Player Name"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.classController,
                decoration: const InputDecoration(labelText: "Class/Department"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.rollNoController,
                decoration: const InputDecoration(labelText: "Roll Number"),
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
                    onPressed: () => controller.savePlayer(teamId, teamName, sportId),
                    child: const Text("Add"),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Assuming team details are passed
    
    return AppScaffold(
      title: "Players",
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPlayerDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ListLoadingWidget();
        }

        if (controller.players.isEmpty) {
          return const Center(child: Text("No players added yet"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.players.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: PlayerTile(
                player: controller.players[index],
                onTap: () {
                  // View player stats
                },
              ),
            );
          },
        );
      }),
    );
  }
}
