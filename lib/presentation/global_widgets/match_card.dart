import "package:flutter/material.dart";
import "package:sportsboard/domain/entities/fixture.dart";
import "package:sportsboard/presentation/global_widgets/status_chip.dart";
import "package:sportsboard/core/utils/date_utils.dart";

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
              // Header: Tournament name & Status
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
              
              // Teams and Score
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTeam(context, fixture.teamAName, fixture.teamALogo),
                  
                  // VS or Score
                  Expanded(
                    child: Column(
                      children: [
                        if (scoreSummary != null)
                          Text(
                            scoreSummary!,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          )
                        else
                          Text(
                            "VS",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).textTheme.bodySmall?.color,
                                ),
                          ),
                      ],
                    ),
                  ),
                  
                  _buildTeam(context, fixture.teamBName, fixture.teamBLogo),
                ],
              ),
              
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              
              // Footer: Date & Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        fixture.date != null ? AppDateUtils.formatDayMonth(fixture.date!) : "TBA",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        fixture.time.isNotEmpty ? fixture.time : "TBA",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeam(BuildContext context, String name, String logoUrl) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            backgroundImage: logoUrl.isNotEmpty ? NetworkImage(logoUrl) : null,
            child: logoUrl.isEmpty
                ? Text(name.isNotEmpty ? name[0].toUpperCase() : "?")
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
