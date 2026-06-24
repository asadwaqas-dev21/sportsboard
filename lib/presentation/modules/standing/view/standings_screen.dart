import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/presentation/global_widgets/app_scaffold.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/global_widgets/standing_table.dart";
import "package:sportsboard/presentation/modules/standing/controller/standing_controller.dart";

class StandingsScreen extends GetView<StandingController> {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming sportTypeStr is passed via arguments to know which columns to show
    final String sportTypeStr = Get.arguments?["sportType"] ?? "football"; 

    return AppScaffold(
      title: "Standings",
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: LoadingWidget(height: 300),
          );
        }

        if (controller.standings.isEmpty) {
          return const Center(child: Text("No standings available"));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: StandingTable(
            standings: controller.standings,
            sportTypeStr: sportTypeStr,
          ),
        );
      }),
    );
  }
}
