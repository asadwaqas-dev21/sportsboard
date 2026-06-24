import "package:flutter/material.dart";
import "package:iconsax/iconsax.dart";
import "package:sportsboard/core/theme/app_colors.dart";

class EmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onActionPressed;
  final String? actionText;

  const EmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Iconsax.box_search,
    this.onActionPressed,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors
                      .textSecondaryLight, // Or contextual secondary color
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onActionPressed != null && actionText != null) ...[
              const SizedBox(height: 32),
              OutlinedButton(
                onPressed: onActionPressed,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
