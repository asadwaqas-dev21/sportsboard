import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/core/theme/app_colors.dart";
import "package:sportsboard/domain/entities/fixture.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/global_widgets/section_header.dart";
import "package:sportsboard/presentation/global_widgets/status_chip.dart";
import "package:sportsboard/presentation/global_widgets/team_avatar.dart";
import "package:sportsboard/presentation/modules/home/controller/home_controller.dart";

class TodayMatchesSection extends GetView<HomeController> {
  const TodayMatchesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: "Today's Matches", onSeeAll: () => controller.changePage(2)),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.isLoadingFixtures.value) {
              return const LoadingWidget(height: 190);
            }

            if (controller.todaysFixtures.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.dividerLight),
                ),
                child: Center(
                  child: Text(
                    "No matches scheduled today",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                  ),
                ),
              );
            }

            return SizedBox(
              height: 190,
              child: PageView.builder(
                itemCount: controller.todaysFixtures.length,
                itemBuilder: (context, index) =>
                    _MatchCard(fixture: controller.todaysFixtures[index]),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final Fixture fixture;
  const _MatchCard({required this.fixture});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "${fixture.sportType.isNotEmpty ? fixture.sportType.capitalize! : "Match"} • ${fixture.tournamentName.isNotEmpty ? fixture.tournamentName : "Inter-Department"}",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              StatusChip(statusKey: fixture.status),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    TeamAvatar(name: fixture.teamAName, logoUrl: fixture.teamALogo),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        fixture.teamAName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "vs",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiaryLight,
                      ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        fixture.teamBName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const SizedBox(width: 10),
                    TeamAvatar(name: fixture.teamBName, logoUrl: fixture.teamBLogo),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Center(
            child: Text(
              "${fixture.time.isNotEmpty ? fixture.time : "TBA"} • ${fixture.venue.isNotEmpty ? fixture.venue : "Venue TBA"}",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textTertiaryLight,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
