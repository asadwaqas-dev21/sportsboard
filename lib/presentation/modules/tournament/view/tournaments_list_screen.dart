import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/presentation/global_widgets/app_scaffold.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/modules/tournament/controller/tournament_controller.dart";

class TournamentsListScreen extends GetView<TournamentController> {
  const TournamentsListScreen({super.key});

  void _showAddTournamentDialog(BuildContext context) {
    // For MVP, we will use a hardcoded sportId or prompt later.
    // Assuming we're adding it for a specific sport if filtered, otherwise default.
    final sportId = "football_id"; // Placeholder
    final sportName = "Football";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Tournament"),
        content: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(labelText: "Tournament Name"),
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
                    onPressed: () => controller.saveTournament(sportId, sportName),
                    child: const Text("Add"),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Assuming sport details are passed via arguments
    // final sport = Get.arguments as Sport;

    return AppScaffold(
      title: "Tournaments",
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTournamentDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ListLoadingWidget();
        }

        if (controller.tournaments.isEmpty) {
          return const Center(child: Text("No tournaments found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.tournaments.length,
          itemBuilder: (context, index) {
            final t = controller.tournaments[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(t.name),
                subtitle: Text("Status: ${t.status}"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to tournament detail (Teams/Standings)
                },
              ),
            );
          },
        );
      }),
    );
  }
}
