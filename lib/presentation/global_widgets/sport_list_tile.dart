import "package:flutter/material.dart";
import "package:sportsboard/core/theme/app_colors.dart";
import "package:sportsboard/domain/entities/sport.dart";

class SportListTile extends StatelessWidget {
  final Sport sport;
  final VoidCallback onTap;

  const SportListTile({super.key, required this.sport, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.dividerLight),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
              ),
              child: Icon(_iconForSport(sport.type), color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                sport.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiaryLight, size: 20),
          ],
        ),
      ),
    );
  }

  IconData _iconForSport(String type) {
    switch (type) {
      case "cricket":
        return Icons.sports_cricket;
      case "football":
        return Icons.sports_soccer;
      case "volleyball":
        return Icons.sports_volleyball;
      case "badminton":
      case "table_tennis":
        return Icons.sports_tennis;
      default:
        return Icons.sports;
    }
  }
}
