import "package:flutter/material.dart";
import "package:sportsboard/domain/entities/team.dart";

class TeamTile extends StatelessWidget {
  final Team team;
  final VoidCallback onTap;
  final Widget? trailing;

  const TeamTile({
    super.key,
    required this.team,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        backgroundImage: team.logoUrl.isNotEmpty ? NetworkImage(team.logoUrl) : null,
        child: team.logoUrl.isEmpty
            ? Text(team.name.isNotEmpty ? team.name[0].toUpperCase() : "?")
            : null,
      ),
      title: Text(
        team.name,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      subtitle: team.captainName.isNotEmpty
          ? Text(
              "Captain: ${team.captainName}",
              style: Theme.of(context).textTheme.bodySmall,
            )
          : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
    );
  }
}
