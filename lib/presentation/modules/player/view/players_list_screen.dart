import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/core/theme/app_colors.dart";
import "package:sportsboard/domain/entities/player.dart";
import "package:sportsboard/domain/entities/sport.dart";
import "package:sportsboard/domain/entities/team.dart";
import "package:sportsboard/domain/entities/player_stats.dart";
import "package:sportsboard/presentation/global_widgets/app_scaffold.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/global_widgets/player_tile.dart";
import "package:sportsboard/presentation/modules/player/controller/player_controller.dart";

class PlayersListScreen extends GetView<PlayerController> {
  const PlayersListScreen({super.key});

  void _showAddPlayerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Player"),
        content: SingleChildScrollView(
          child: Form(
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
                  decoration: const InputDecoration(
                    labelText: "Class/Department",
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.rollNoController,
                  decoration: const InputDecoration(labelText: "Roll Number"),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  if (controller.teamsList.isEmpty) {
                    return const Text(
                      "Please add a Team first.",
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    );
                  }
                  return DropdownButtonFormField<Team>(
                    // ignore: deprecated_member_use
                    value: controller.selectedTeam.value,
                    decoration: const InputDecoration(labelText: "Select Team"),
                    items: controller.teamsList
                        .map(
                          (team) => DropdownMenuItem(
                            value: team,
                            child: Text(team.name),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      controller.selectedTeam.value = val;
                    },
                    validator: (val) => val == null ? "Required" : null,
                  );
                }),
                const SizedBox(height: 16),
                Obx(() {
                  if (controller.sports.isEmpty) {
                    return const Text(
                      "Please add a Sport first.",
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    );
                  }
                  return DropdownButtonFormField<Sport>(
                    // ignore: deprecated_member_use
                    value: controller.selectedSport.value,
                    decoration: const InputDecoration(
                      labelText: "Select Sport",
                    ),
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
                      final selectedT = controller.selectedTeam.value;
                      final selectedS = controller.selectedSport.value;
                      if (selectedT != null && selectedS != null) {
                        controller.savePlayer(
                          selectedT.id,
                          selectedT.name,
                          selectedS.id,
                        );
                      } else {
                        Get.snackbar(
                          "Error",
                          "Please select a team and a sport",
                        );
                      }
                    },
                    child: const Text("Add"),
                  ),
          ),
        ],
      ),
    );
  }

  void _showPlayerProfileDialog(BuildContext context, Player player) {
    final sport = controller.sports.firstWhereOrNull(
      (s) => s.id == player.sportId,
    );
    final sportName = sport?.name ?? "Unknown Sport";
    final sportType = sport?.type.toLowerCase() ?? "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            player.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: FutureBuilder<PlayerStats?>(
            future: controller.getPlayerStatsForPlayer(player.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final stats = snapshot.data;
              final rankingPoints = stats?.rankingPoints ?? 0;

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileRow(
                      "Team",
                      player.teamName.isNotEmpty ? player.teamName : "No Team",
                    ),
                    _buildProfileRow("Sport", sportName),
                    _buildProfileRow(
                      "Class",
                      player.className.isNotEmpty ? player.className : "N/A",
                    ),
                    _buildProfileRow(
                      "Roll No",
                      player.rollNo.isNotEmpty ? player.rollNo : "N/A",
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Performance Points:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "$rankingPoints PTS",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (stats != null) ...[
                      const SizedBox(height: 16),
                      const Text(
                        "Statistics:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (sportType == "cricket") ...[
                        _buildProfileRow("Matches", "${stats.matches}"),
                        _buildProfileRow("Batting Runs", "${stats.runs}"),
                        _buildProfileRow("Wickets", "${stats.wickets}"),
                        _buildProfileRow("Maidens", "${stats.maidens}"),
                        _buildProfileRow("Overs", "${stats.overs}"),
                        _buildProfileRow("Catches", "${stats.catches}"),
                      ] else if (sportType == "football") ...[
                        _buildProfileRow("Goals", "${stats.goals}"),
                        _buildProfileRow("Assists", "${stats.assists}"),
                        _buildProfileRow(
                          "Clean Sheets",
                          "${stats.cleanSheets}",
                        ),
                        _buildProfileRow(
                          "Yellow Cards",
                          "${stats.yellowCards}",
                        ),
                        _buildProfileRow("Red Cards", "${stats.redCards}"),
                        _buildProfileRow("Man of Match", "${stats.manOfMatch}"),
                      ] else ...[
                        const Text(
                          "No detailed stats available for this sport type.",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text("Close")),
          ],
        );
      },
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teamArgs = Get.arguments as Team?;
    final title = teamArgs != null ? "${teamArgs.name} Players" : "Players";

    return AppScaffold(
      title: title,
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
            final player = controller.players[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: PlayerTile(
                player: player,
                onTap: () => _showPlayerProfileDialog(context, player),
              ),
            );
          },
        );
      }),
    );
  }
}
