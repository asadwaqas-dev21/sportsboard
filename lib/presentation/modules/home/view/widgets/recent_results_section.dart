import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/domain/entities/fixture.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/global_widgets/match_card.dart";
import "package:sportsboard/presentation/global_widgets/section_header.dart";
import "package:sportsboard/presentation/modules/home/controller/home_controller.dart";

class RecentResultsSection extends GetView<HomeController> {
  const RecentResultsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: "Latest Results",
            onSeeAll: () {},
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.isLoadingResults.value) {
              return const ListLoadingWidget(count: 3);
            }

            if (controller.recentResults.isEmpty) {
              return Card(
                elevation: 0,
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.3),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      "No recent results",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.recentResults.length,
              itemBuilder: (context, index) {
                final result = controller.recentResults[index];
                final dummyFixture = Fixture(
                  id: result.fixtureId,
                  tournamentId: result.tournamentId,
                  teamAId: "",
                  teamBId: "",
                  teamAName: result.teamAName,
                  teamBName: result.teamBName,
                  status: "completed",
                  date: result.createdAt,
                );

                return MatchCard(
                  fixture: dummyFixture,
                  scoreSummary: result.scoreSummary,
                  onTap: () {},
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
