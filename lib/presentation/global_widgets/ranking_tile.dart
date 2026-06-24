import "package:flutter/material.dart";
import "package:sportsboard/domain/entities/player_stats.dart";
import "package:sportsboard/core/theme/app_colors.dart";

class RankingTile extends StatelessWidget {
  final int rank;
  final PlayerStats stats;
  final VoidCallback onTap;
  final String primaryStatLabel;
  final String primaryStatValue;

  const RankingTile({
    super.key,
    required this.rank,
    required this.stats,
    required this.onTap,
    required this.primaryStatLabel,
    required this.primaryStatValue,
  });

  @override
  Widget build(BuildContext context) {
    final isTopThree = rank <= 3;
    Color? rankColor;
    if (rank == 1) {
      rankColor = const Color(0xFFFFD700); // Gold
      // ignore: curly_braces_in_flow_control_structures
    } else if (rank == 2)
      // ignore: curly_braces_in_flow_control_structures
      rankColor = const Color(0xFFC0C0C0); // Silver
    // ignore: curly_braces_in_flow_control_structures
    else if (rank == 3)
      // ignore: curly_braces_in_flow_control_structures
      rankColor = const Color(0xFFCD7F32); // Bronze

    return ListTile(
      onTap: onTap,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 32,
            child: Center(
              child: Text(
                "#$rank",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: rankColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest,
            child: Text(
              stats.playerName.isNotEmpty
                  ? stats.playerName[0].toUpperCase()
                  : "?",
            ),
          ),
        ],
      ),
      title: Text(
        stats.playerName,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: isTopThree ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        stats.teamName,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            primaryStatValue,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          Text(primaryStatLabel, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
