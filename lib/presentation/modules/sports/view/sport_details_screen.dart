import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:sportsboard/app/routes/app_routes.dart";
import "package:sportsboard/core/theme/app_colors.dart";
import "package:sportsboard/core/utils/date_utils.dart";
import "package:sportsboard/domain/entities/sport.dart";
import "package:sportsboard/domain/entities/tournament.dart";
import "package:sportsboard/domain/usecases/tournament/get_tournaments_usecase.dart";
import "package:sportsboard/presentation/global_widgets/empty_state.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/global_widgets/status_chip.dart";
import "package:sportsboard/presentation/modules/sports/controller/sport_details_controller.dart";

class SportDetailsScreen extends StatelessWidget {
  const SportDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Sport? sport = Get.arguments as Sport?;
    if (sport == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Sport not found. Please go back.")),
      );
    }

    final controller = Get.put(
      SportDetailsController(
        getTournamentsUseCase: Get.find<GetTournamentsUseCase>(),
        sportId: sport.id,
      ),
      tag: sport.id,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(sport.name),
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ListLoadingWidget(count: 4, itemHeight: 80);
        }

        final tournaments = controller.tournaments;
        final active = tournaments.where((t) => t.status == "active").length;
        final completed = tournaments.where((t) => t.status == "completed").length;

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            _StatsRow(
              total: tournaments.length,
              active: active,
              completed: completed,
            ),
            const SizedBox(height: 24),
            if (tournaments.isEmpty)
              const EmptyState(
                title: "No Tournaments",
                subtitle: "No tournaments have been created for this sport yet.",
                icon: Iconsax.cup,
              )
            else ...[
              Text(
                "TOURNAMENTS",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      letterSpacing: 1.2,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5),
                    ),
              ),
              const SizedBox(height: 10),
              for (final t in tournaments) _TournamentCard(tournament: t),
            ],
          ],
        );
      }),
    );
  }
}

// ── Stats Row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final int total;
  final int active;
  final int completed;

  const _StatsRow({
    required this.total,
    required this.active,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatBox(label: "Total", value: "$total")),
        const SizedBox(width: 10),
        Expanded(
          child: _StatBox(label: "Active", value: "$active", highlight: true),
        ),
        const SizedBox(width: 10),
        Expanded(child: _StatBox(label: "Completed", value: "$completed")),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _StatBox({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = highlight
        ? AppColors.primary
        : Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.45);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: highlight ? Colors.white : null,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: highlight
                      ? Colors.white70
                      : Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                ),
          ),
        ],
      ),
    );
  }
}

// ── Tournament Card ───────────────────────────────────────────────────────────

class _TournamentCard extends StatelessWidget {
  final Tournament tournament;
  const _TournamentCard({required this.tournament});

  @override
  Widget build(BuildContext context) {
    final dateLabel = _dateRange(tournament);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.primarySurface,
            shape: BoxShape.circle,
          ),
          child: const Icon(Iconsax.cup, color: AppColors.primary, size: 20),
        ),
        title: Text(
          tournament.name,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: dateLabel.isNotEmpty
            ? Text(
                dateLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                    ),
              )
            : null,
        trailing: StatusChip(statusKey: tournament.status),
        onTap: () =>
            Get.toNamed(AppRoutes.tournamentDetails, arguments: tournament),
      ),
    );
  }

  String _dateRange(Tournament t) {
    if (t.startDate == null) return "";
    final start = AppDateUtils.formatDayMonth(t.startDate!);
    if (t.endDate == null) return start;
    return "$start – ${AppDateUtils.formatDayMonth(t.endDate!)}";
  }
}
