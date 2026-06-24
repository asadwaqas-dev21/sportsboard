// ignore_for_file: deprecated_member_use

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/core/theme/app_colors.dart";

import "package:sportsboard/domain/entities/fixture.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/global_widgets/section_header.dart";
import "package:sportsboard/presentation/global_widgets/status_chip.dart";
import "package:sportsboard/presentation/modules/home/controller/home_controller.dart";

class TodayMatchesSection extends GetView<HomeController> {
  const TodayMatchesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: "Today's Matches",
            onSeeAll: () => controller.changePage(2),
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.isLoadingFixtures.value) {
              return const LoadingWidget(height: 200);
            }

            if (controller.todaysFixtures.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.dividerLight),
                ),
                child: Center(
                  child: Text(
                    "No matches scheduled today",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                  ),
                ),
              );
            }

            return SizedBox(
              height: 210,
              child: PageView.builder(
                itemCount: controller.todaysFixtures.length,
                itemBuilder: (context, index) {
                  final fixture = controller.todaysFixtures[index];
                  return _buildLiveMatchCard(context, fixture);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLiveMatchCard(BuildContext context, Fixture fixture) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Sport Type • Tournament Name + Status
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

            // Teams Row
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildTeamAvatar(context, fixture.teamAName, fixture.teamALogo),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          fixture.teamAName,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
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
                          fontWeight: FontWeight.w500,
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
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildTeamAvatar(context, fixture.teamBName, fixture.teamBLogo),
                    ],
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Footer: Time & Venue
            Center(
              child: Text(
                "${fixture.time.isNotEmpty ? fixture.time : "TBA"} • ${fixture.venue.isNotEmpty ? fixture.venue : "Venue"}",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textTertiaryLight,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamAvatar(BuildContext context, String name, String logoUrl) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primarySurface,
        border: Border.all(color: AppColors.dividerLight),
        image: logoUrl.isNotEmpty
            ? DecorationImage(image: NetworkImage(logoUrl), fit: BoxFit.cover)
            : null,
      ),
      child: logoUrl.isEmpty
          ? Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : "?",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
            )
          : null,
    );
  }
}
