import "package:flutter/material.dart";
import "package:sportsboard/core/utils/date_utils.dart";
import "package:sportsboard/domain/entities/fixture.dart";
import "package:sportsboard/presentation/global_widgets/status_chip.dart";
import "package:sportsboard/presentation/global_widgets/team_avatar.dart";

class MatchCard extends StatelessWidget {
  final Fixture fixture;
  final String? scoreSummary;
  final VoidCallback onTap;

  const MatchCard({
    super.key,
    required this.fixture,
    this.scoreSummary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      fixture.tournamentName,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  StatusChip(statusKey: fixture.status),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _TeamBlock(name: fixture.teamAName, logoUrl: fixture.teamALogo)),
                  Expanded(
                    child: Center(
                      child: scoreSummary != null
                          ? Text(
                              scoreSummary!,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              "VS",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                  ),
                            ),
                    ),
                  ),
                  Expanded(child: _TeamBlock(name: fixture.teamBName, logoUrl: fixture.teamBLogo)),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _IconLabel(
                    icon: Icons.calendar_today,
                    label: fixture.date != null
                        ? AppDateUtils.formatDayMonth(fixture.date!)
                        : "TBA",
                  ),
                  _IconLabel(
                    icon: Icons.access_time,
                    label: fixture.time.isNotEmpty ? fixture.time : "TBA",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamBlock extends StatelessWidget {
  final String name;
  final String logoUrl;
  const _TeamBlock({required this.name, required this.logoUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TeamAvatar(name: name, logoUrl: logoUrl, size: 48),
        const SizedBox(height: 8),
        Text(
          name,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _IconLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  const _IconLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
