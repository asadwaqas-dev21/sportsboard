// ignore_for_file: deprecated_member_use

import "package:flutter/material.dart";
import "package:sportsboard/domain/entities/sport.dart";

class SportCard extends StatelessWidget {
  final Sport sport;
  final VoidCallback onTap;

  const SportCard({super.key, required this.sport, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconForSport(sport.type),
                color: Theme.of(context).colorScheme.primary,
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                sport.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForSport(String type) {
    switch (type) {
      case "cricket":
        return Icons.sports_cricket;
      case "football":
        return Icons.sports_soccer;
      case "badminton":
        return Icons.sports_tennis; // Close enough for badminton
      case "table_tennis":
        return Icons.sports_tennis;
      case "volleyball":
        return Icons.sports_volleyball;
      default:
        return Icons.sports;
    }
  }
}
