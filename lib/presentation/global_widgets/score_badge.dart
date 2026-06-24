// ignore_for_file: deprecated_member_use

import "package:flutter/material.dart";

class ScoreBadge extends StatelessWidget {
  final String score;
  final Color? color;
  final double fontSize;

  const ScoreBadge({
    super.key,
    required this.score,
    this.color,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        score,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: color ?? Theme.of(context).colorScheme.primary,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
