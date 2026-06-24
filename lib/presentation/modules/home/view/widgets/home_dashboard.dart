import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/presentation/modules/home/controller/home_controller.dart";
import "package:sportsboard/presentation/modules/home/view/widgets/announcements_section.dart";
import "package:sportsboard/presentation/modules/home/view/widgets/recent_results_section.dart";
import "package:sportsboard/presentation/modules/home/view/widgets/sports_list_section.dart";
import "package:sportsboard/presentation/modules/home/view/widgets/today_matches_section.dart";

class HomeDashboard extends GetView<HomeController> {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Greeting(greeting: controller.getGreeting()),
          const TodayMatchesSection(),
          const SizedBox(height: 24),
          const SportsListSection(),
          const SizedBox(height: 24),
          const RecentResultsSection(),
          const SizedBox(height: 24),
          const AnnouncementsSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  final String greeting;
  const _Greeting({required this.greeting});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                ),
          ),
          const SizedBox(height: 2),
          Text(
            "SportsBoard",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
