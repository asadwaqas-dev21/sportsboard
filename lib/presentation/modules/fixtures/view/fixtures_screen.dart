import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:sportsboard/presentation/global_widgets/empty_state.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/global_widgets/match_card.dart";
import "package:sportsboard/presentation/modules/home/controller/home_controller.dart";

class FixturesScreen extends GetView<HomeController> {
  const FixturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingFixtures.value) {
        return const ListLoadingWidget(count: 5, itemHeight: 160);
      }

      if (controller.todaysFixtures.isEmpty) {
        return const EmptyState(
          title: "No Fixtures Today",
          subtitle: "Check back later for scheduled matches.",
          icon: Iconsax.calendar_1,
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: controller.todaysFixtures.length,
        itemBuilder: (context, index) =>
            MatchCard(fixture: controller.todaysFixtures[index], onTap: () {}),
      );
    });
  }
}
