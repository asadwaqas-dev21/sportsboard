import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/presentation/global_widgets/app_scaffold.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/global_widgets/ranking_tile.dart";
import "package:sportsboard/presentation/modules/ranking/controller/ranking_controller.dart";

class RankingsScreen extends GetView<RankingController> {
  const RankingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String sportTypeStr = Get.arguments?["sportType"] ?? "football";
    final String primaryStatLabel = controller.getPrimaryStatLabel(sportTypeStr);

    return AppScaffold(
      title: "Player Rankings",
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ListLoadingWidget();
        }

        if (controller.rankings.isEmpty) {
          return const Center(child: Text("No rankings available"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.rankings.length,
          itemBuilder: (context, index) {
            final stats = controller.rankings[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: RankingTile(
                rank: index + 1,
                stats: stats,
                primaryStatLabel: primaryStatLabel,
                primaryStatValue: controller.getPrimaryStatValue(stats, sportTypeStr),
                onTap: () {
                  // View full player stats
                },
              ),
            );
          },
        );
      }),
    );
  }
}
