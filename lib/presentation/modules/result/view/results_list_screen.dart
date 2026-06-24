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
                Obx(() {
                  final fixture = controller.selectedFixture.value;
                  if (fixture == null) return const SizedBox.shrink();

                  final sType = fixture.sportType.toLowerCase();
                  if (sType.contains("cricket")) {
                    return _buildCricketForm(fixture);
                  } else if (sType.contains("football")) {
                    return _buildFootballForm(fixture);
                  } else if (sType.contains("badminton")) {
                    return _buildBadmintonForm(fixture);
                  } else {
                    return _buildGenericForm();
                  }
                }),
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

  Widget _buildCricketForm(Fixture fixture) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text("${fixture.teamAName} Innings:", style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.teamARunsController,
                decoration: const InputDecoration(labelText: "Runs"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: controller.teamAWicketsController,
                decoration: const InputDecoration(labelText: "Wkts"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: controller.teamAOversController,
                decoration: const InputDecoration(labelText: "Overs"),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text("${fixture.teamBName} Innings:", style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.teamBRunsController,
                decoration: const InputDecoration(labelText: "Runs"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: controller.teamBWicketsController,
                decoration: const InputDecoration(labelText: "Wkts"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: controller.teamBOversController,
                decoration: const InputDecoration(labelText: "Overs"),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFootballForm(Fixture fixture) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.teamAGoalsController,
                decoration: InputDecoration(labelText: "${fixture.teamAName} Goals"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: controller.teamBGoalsController,
                decoration: InputDecoration(labelText: "${fixture.teamBName} Goals"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadmintonForm(Fixture fixture) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.teamASetsController,
                decoration: InputDecoration(labelText: "${fixture.teamAName} Sets Won"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: controller.teamBSetsController,
                decoration: InputDecoration(labelText: "${fixture.teamBName} Sets Won"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller.setScoresController,
          decoration: const InputDecoration(
            labelText: "Set Scores (e.g. 21-18, 19-21, 21-15)",
            hintText: "Optional details",
          ),
        ),
      ],
    );
  }

  Widget _buildGenericForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.scoreSummaryController,
          decoration: const InputDecoration(
            labelText: "Score Summary (e.g. 2-1 or 150/4 - 148/8)",
          ),
          validator: (v) => v!.isEmpty ? "Required" : null,
        ),
      ],
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
