import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/core/utils/date_utils.dart";
import "package:sportsboard/domain/entities/team.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/global_widgets/match_card.dart";
import "package:sportsboard/presentation/global_widgets/standing_table.dart";
import "package:sportsboard/presentation/modules/tournament/controller/tournament_details_controller.dart";

class TournamentDetailsScreen extends GetView<TournamentDetailsController> {
  const TournamentDetailsScreen({super.key});

  // --- DIALOGS ---

  void _showAddTeamDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Participant Team"),
        content: Form(
          key: controller.addTeamFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller.teamNameController,
                decoration: const InputDecoration(
                  labelText: "Team Name",
                  hintText: "Enter team name",
                ),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.teamCaptainController,
                decoration: const InputDecoration(
                  labelText: "Captain Name",
                  hintText: "Enter captain name",
                ),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
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
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : ElevatedButton(
                    onPressed: () => controller.addTeam(),
                    child: const Text("Add"),
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddFixtureDialog(BuildContext context) {
    controller.selectedDate.value = null;
    controller.fixtureTimeController.clear();
    controller.fixtureVenueController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Fixture"),
        content: SingleChildScrollView(
          child: Form(
            key: controller.addFixtureFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() {
                  if (controller.teams.isEmpty) {
                    return const Text(
                      "Please add participant teams first.",
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    );
                  }
                  return DropdownButtonFormField<Team>(
                    // ignore: deprecated_member_use
                    value: controller.selectedTeamA.value,
                    decoration: const InputDecoration(labelText: "Team A"),
                    items: controller.teams
                        .map(
                          (team) => DropdownMenuItem(
                            value: team,
                            child: Text(team.name),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => controller.selectedTeamA.value = val,
                    validator: (val) => val == null ? "Required" : null,
                  );
                }),
                const SizedBox(height: 16),
                Obx(() {
                  if (controller.teams.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return DropdownButtonFormField<Team>(
                    // ignore: deprecated_member_use
                    value: controller.selectedTeamB.value,
                    decoration: const InputDecoration(labelText: "Team B"),
                    items: controller.teams
                        .map(
                          (team) => DropdownMenuItem(
                            value: team,
                            child: Text(team.name),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => controller.selectedTeamB.value = val,
                    validator: (val) => val == null ? "Required" : null,
                  );
                }),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2025),
                      lastDate: DateTime(2035),
                    );
                    if (picked != null) {
                      controller.selectedDate.value = picked;
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: "Match Date"),
                    child: Obx(
                      () => Text(
                        controller.selectedDate.value == null
                            ? "Select Date"
                            : AppDateUtils.formatDayMonth(
                                controller.selectedDate.value!,
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.fixtureTimeController,
                  decoration: const InputDecoration(
                    labelText: "Match Time (e.g. 14:00 or 7:00 PM)",
                  ),
                  readOnly: true,
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null && context.mounted) {
                      controller.fixtureTimeController.text = picked.format(
                        context,
                      );
                    }
                  },
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.fixtureVenueController,
                  decoration: const InputDecoration(
                    labelText: "Venue / Ground",
                  ),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          Obx(
            () => controller.isSaving.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : ElevatedButton(
                    onPressed: () => controller.addFixture(),
                    child: const Text("Add"),
                  ),
          ),
        ],
      ),
    );
  }

  void _showEditStandingDialog(BuildContext context) {
    controller.standingSelectedTeam.value = null;
    controller.standingPlayedController.clear();
    controller.standingWonController.clear();
    controller.standingLostController.clear();
    controller.standingDrawController.clear();
    controller.standingPointsController.clear();
    controller.standingNrrController.clear();
    controller.standingGoalsForController.clear();
    controller.standingGoalsAgainstController.clear();

    showDialog(
      context: context,
      builder: (context) {
        final isCricket = controller.sportTypeStr == "cricket";
        final isFootball = controller.sportTypeStr == "football";

        return AlertDialog(
          title: const Text("Manual Standing Entry"),
          content: SingleChildScrollView(
            child: Form(
              key: controller.editStandingFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    if (controller.teams.isEmpty) {
                      return const Text(
                        "Please add participant teams first.",
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      );
                    }
                    return DropdownButtonFormField<Team>(
                      // ignore: deprecated_member_use
                      value: controller.standingSelectedTeam.value,
                      decoration: const InputDecoration(
                        labelText: "Select Team",
                      ),
                      items: controller.teams
                          .map(
                            (team) => DropdownMenuItem(
                              value: team,
                              child: Text(team.name),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        controller.standingSelectedTeam.value = val;
                        if (val != null) {
                          // Auto fill existing standing if exists
                          final existing = controller.standings
                              .firstWhereOrNull((s) => s.teamId == val.id);
                          if (existing != null) {
                            controller.standingPlayedController.text = existing
                                .played
                                .toString();
                            controller.standingWonController.text = existing.won
                                .toString();
                            controller.standingLostController.text = existing
                                .lost
                                .toString();
                            controller.standingDrawController.text = existing
                                .draw
                                .toString();
                            controller.standingPointsController.text = existing
                                .points
                                .toString();
                            controller.standingNrrController.text = existing
                                .netRunRate
                                .toString();
                            controller.standingGoalsForController.text =
                                existing.goalsFor.toString();
                            controller.standingGoalsAgainstController.text =
                                existing.goalsAgainst.toString();
                          }
                        }
                      },
                      validator: (val) => val == null ? "Required" : null,
                    );
                  }),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.standingPlayedController,
                    decoration: const InputDecoration(
                      labelText: "Played (Matches)",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.standingWonController,
                          decoration: const InputDecoration(labelText: "Won"),
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? "Required" : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: controller.standingLostController,
                          decoration: const InputDecoration(labelText: "Lost"),
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? "Required" : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (isFootball) ...[
                        Expanded(
                          child: TextFormField(
                            controller: controller.standingDrawController,
                            decoration: const InputDecoration(
                              labelText: "Draws",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? "Required" : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: TextFormField(
                          controller: controller.standingPointsController,
                          decoration: const InputDecoration(
                            labelText: "Points",
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? "Required" : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (isCricket)
                    TextFormField(
                      controller: controller.standingNrrController,
                      decoration: const InputDecoration(
                        labelText: "Net Run Rate (NRR)",
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (v) => v!.isEmpty ? "Required" : null,
                    ),
                  if (isFootball) ...[
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.standingGoalsForController,
                            decoration: const InputDecoration(
                              labelText: "Goals For (GF)",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? "Required" : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller:
                                controller.standingGoalsAgainstController,
                            decoration: const InputDecoration(
                              labelText: "Goals Against (GA)",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? "Required" : null,
                          ),
                        ),
                      ],
                    ),
                  ],
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
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : ElevatedButton(
                      onPressed: () => controller.addOrUpdateStanding(),
                      child: const Text("Save"),
                    ),
            ),
          ],
        );
      },
    );
  }

  // --- TAB VIEWS ---

  Widget _buildTeamsTab(BuildContext context) {
    return Scaffold(
      floatingActionButton: controller.isAdmin
          ? FloatingActionButton(
              heroTag: "add_team_fab",
              onPressed: () => _showAddTeamDialog(context),
              child: const Icon(Icons.group_add),
            )
          : null,
      body: Obx(() {
        if (controller.isLoadingTeams.value) {
          return const ListLoadingWidget(count: 3, itemHeight: 80);
        }

        if (controller.teams.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.group_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text("No participant teams found"),
                if (controller.isAdmin) ...[
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _showAddTeamDialog(context),
                    child: const Text("Add Team"),
                  ),
                ],
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.teams.length,
          itemBuilder: (context, index) {
            final team = controller.teams[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  child: Text(
                    team.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  team.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  "Captain: ${team.captainName.isNotEmpty ? team.captainName : 'N/A'}",
                ),
                trailing: const Icon(Icons.chevron_right, size: 20),
                onTap: () {
                  // Navigate to players screen pre-filtered by team
                  Get.toNamed("/players", arguments: team);
                },
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildStandingsTab(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoadingStandings.value ||
            controller.isLoadingTeams.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final standingList = controller.standings;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.isAdmin) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text("Recalculate"),
                      onPressed: () => controller.recalculateStandings(),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text("Manual Entry"),
                      onPressed: () => _showEditStandingDialog(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              if (standingList.isEmpty) ...[
                const SizedBox(height: 64),
                Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.leaderboard_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "No standings available yet",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Add standing values manually or click Recalculate if results are entered.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                StandingTable(
                  standings: standingList,
                  sportTypeStr: controller.sportTypeStr,
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFixturesTab(BuildContext context) {
    return Scaffold(
      floatingActionButton: controller.isAdmin
          ? FloatingActionButton(
              heroTag: "add_fixture_fab",
              onPressed: () => _showAddFixtureDialog(context),
              child: const Icon(Icons.event),
            )
          : null,
      body: Obx(() {
        if (controller.isLoadingFixtures.value) {
          return const ListLoadingWidget(count: 3, itemHeight: 140);
        }

        if (controller.fixtures.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text("No fixtures scheduled yet"),
                if (controller.isAdmin) ...[
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _showAddFixtureDialog(context),
                    child: const Text("Add Fixture"),
                  ),
                ],
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.fixtures.length,
          itemBuilder: (context, index) {
            final fixture = controller.fixtures[index];
            return MatchCard(
              fixture: fixture,
              onTap: () {
                if (controller.isAdmin) {
                  // Navigate to Results page to add/update result for this match
                  Get.toNamed("/results");
                }
              },
            );
          },
        );
      }),
    );
  }

  // --- BUILD ---

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(controller.tournament.name),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Get.back(),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Teams"),
              Tab(text: "Standings"),
              Tab(text: "Fixtures"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTeamsTab(context),
            _buildStandingsTab(context),
            _buildFixturesTab(context),
          ],
        ),
      ),
    );
  }
}
