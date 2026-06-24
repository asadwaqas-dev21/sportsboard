import "package:flutter/material.dart";
import "package:sportsboard/core/theme/app_colors.dart";

class TeamAvatar extends StatelessWidget {
  final String name;
  final String logoUrl;
  final double size;

  const TeamAvatar({
    super.key,
    required this.name,
    this.logoUrl = "",
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primarySurface,
        border: Border.all(color: AppColors.dividerLight),
        image: logoUrl.isNotEmpty
            ? DecorationImage(image: NetworkImage(logoUrl), fit: BoxFit.cover)
            : null,
      ),
      child: logoUrl.isEmpty
          ? Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : "?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: size * 0.35,
                ),
              ),
            )
          : null,
    );
  }
}
