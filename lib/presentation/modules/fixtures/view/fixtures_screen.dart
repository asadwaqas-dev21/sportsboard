import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/global_widgets/match_card.dart";
import "package:sportsboard/presentation/modules/home/controller/home_controller.dart";

class FixturesScreen extends GetView<HomeController> {
  const FixturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Fixtures",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoadingFixtures.value) {
                      return const ListLoadingWidget(count: 5, itemHeight: 160);
                    }

                    if (controller.todaysFixtures.isEmpty) {
                      return const Center(
                        child: Text("No matches scheduled today"),
                      );
                    }

                    return ListView.builder(
                      itemCount: controller.todaysFixtures.length,
                      itemBuilder: (context, index) {
                        final fixture = controller.todaysFixtures[index];
                        return MatchCard(fixture: fixture, onTap: () {});
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
