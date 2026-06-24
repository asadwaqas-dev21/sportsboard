import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/app/routes/app_routes.dart";
import "package:sportsboard/domain/entities/sport.dart";
import "package:sportsboard/presentation/global_widgets/app_scaffold.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/modules/tournament/controller/tournament_controller.dart";

class TournamentsListScreen extends GetView<TournamentController> {
  const TournamentsListScreen({super.key});

  void _showAddTournamentDialog(BuildContext context) {
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
              const SizedBox(height: 16),
              Obx(() {
                if (controller.sports.isEmpty) {
                  return const Text(
                    "Please add a Sport first under 'Manage Sports' in the dashboard.",
                    style: TextStyle(color: Colors.red, fontSize: 13),
                  );
                }
                return DropdownButtonFormField<Sport>(
                  // ignore: deprecated_member_use
                  value: controller.selectedSport.value,
                  decoration: const InputDecoration(labelText: "Select Sport"),
                  items: controller.sports
                      .map(
                        (sport) => DropdownMenuItem(
                          value: sport,
                          child: Text(sport.name),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    controller.selectedSport.value = val;
                  },
                  validator: (val) => val == null ? "Required" : null,
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          Obx(
            () => controller.isSaving.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: () {
                      final selected = controller.selectedSport.value;
                      if (selected != null) {
                        controller.saveTournament(selected.id, selected.name);
                      } else {
                        Get.snackbar("Error", "Please select a sport");
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
                  Get.toNamed(AppRoutes.tournamentDetails, arguments: t);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
