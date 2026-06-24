import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/domain/entities/tournament.dart";
import "package:sportsboard/domain/entities/team.dart";
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
        content: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                const SizedBox(height: 16),
                Obx(() {
                  if (controller.teams.isEmpty) {
                    return const Text(
                      "Please add Teams first.",
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    );
                  }
                  return DropdownButtonFormField<Team>(
                    // ignore: deprecated_member_use
                    value: controller.selectedTeamA.value,
                    decoration: const InputDecoration(labelText: "Select Team A"),
                    items: controller.teams
                        .map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(t.name),
                            ))
                        .toList(),
                    onChanged: (val) {
                      controller.selectedTeamA.value = val;
                    },
                    validator: (val) => val == null ? "Required" : null,
                  );
                }),
                const SizedBox(height: 16),
                Obx(() {
                  if (controller.teams.isEmpty) {
                    return const Text(
                      "Please add Teams first.",
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    );
                  }
                  return DropdownButtonFormField<Team>(
                    // ignore: deprecated_member_use
                    value: controller.selectedTeamB.value,
                    decoration: const InputDecoration(labelText: "Select Team B"),
                    items: controller.teams
                        .map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(t.name),
                            ))
                        .toList(),
                    onChanged: (val) {
                      controller.selectedTeamB.value = val;
                    },
                    validator: (val) => val == null ? "Required" : null,
                  );
                }),
              ],
            ),
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
