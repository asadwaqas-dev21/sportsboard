import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:sportsboard/domain/entities/fixture.dart";
import "package:sportsboard/domain/repositories/auth_repository.dart";
import "package:sportsboard/presentation/global_widgets/empty_state.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/global_widgets/match_card.dart";
import "package:sportsboard/presentation/modules/result/controller/result_controller.dart";

class ResultsListScreen extends GetView<ResultController> {
  const ResultsListScreen({super.key});

  void _showAddResultDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Match Result"),
        content: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() {
                  if (controller.fixtures.isEmpty) {
                    return const Text(
                      "Please add a Fixture first.",
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    );
                  }
                  return DropdownButtonFormField<Fixture>(
                    // ignore: deprecated_member_use
                    value: controller.selectedFixture.value,
                    decoration: const InputDecoration(labelText: "Select Fixture"),
                    items: controller.fixtures
                        .map((f) => DropdownMenuItem(
                              value: f,
                              child: Text("${f.teamAName} vs ${f.teamBName}"),
                            ))
                        .toList(),
                    onChanged: (val) {
                      controller.selectedFixture.value = val;
                    },
                    validator: (val) => val == null ? "Required" : null,
                  );
                }),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.scoreSummaryController,
                  decoration: const InputDecoration(
                    labelText: "Score Summary (e.g. 2-1 or 150/4 - 148/8)",
                  ),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Winner Team:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  final fixture = controller.selectedFixture.value;
                  if (fixture == null) {
                    return const Text("Select a fixture first");
                  }
                  return Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: Text(fixture.teamAName),
                          selected: controller.isTeamAWinner.value,
                          onSelected: (val) {
                            if (val) controller.isTeamAWinner.value = true;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ChoiceChip(
                          label: Text(fixture.teamBName),
                          selected: !controller.isTeamAWinner.value,
                          onSelected: (val) {
                            if (val) controller.isTeamAWinner.value = false;
                          },
                        ),
                      ),
                    ],
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
                    onPressed: () => controller.addResult(),
                    child: const Text("Save"),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    final isAdmin = Get.find<AuthRepository>().isLoggedIn;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: canPop
          ? AppBar(
              title: const Text("Results"),
              centerTitle: false,
            )
          : null,
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () => _showAddResultDialog(context),
              child: const Icon(Icons.add),
            )
          : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ListLoadingWidget(count: 5, itemHeight: 160);
        }

        if (controller.results.isEmpty) {
          return const EmptyState(
            title: "No Results Yet",
            subtitle: "Match results will appear here.",
            icon: Iconsax.chart_1,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: controller.results.length,
          itemBuilder: (context, index) {
            final r = controller.results[index];
            return MatchCard(
              fixture: Fixture(
                id: r.fixtureId,
                tournamentId: r.tournamentId,
                teamAId: "",
                teamBId: "",
                teamAName: r.teamAName,
                teamBName: r.teamBName,
                status: "completed",
                date: r.createdAt,
              ),
              scoreSummary: r.scoreSummary,
              onTap: () {},
            );
          },
        );
      }),
    );
  }
}
