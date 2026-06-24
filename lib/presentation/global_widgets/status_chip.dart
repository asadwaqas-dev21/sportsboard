// ignore_for_file: deprecated_member_use

import "package:flutter/material.dart";
import "package:sportsboard/core/theme/app_colors.dart";
import "package:sportsboard/core/enums/match_status.dart";

class StatusChip extends StatelessWidget {
  final String statusKey;

  const StatusChip({super.key, required this.statusKey});

  @override
  Widget build(BuildContext context) {
    final status = MatchStatus.fromKey(statusKey);
    Color color;

    switch (status) {
      case MatchStatus.upcoming:
        color = AppColors.info;
        break;
      case MatchStatus.live:
        color = AppColors.error; // Red for live
        break;
      case MatchStatus.completed:
        color = AppColors.success;
        break;
      case MatchStatus.postponed:
      case MatchStatus.cancelled:
        color = AppColors.warning;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status.isLive) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            status.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
