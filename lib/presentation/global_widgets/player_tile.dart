import "package:flutter/material.dart";
import "package:sportsboard/domain/entities/player.dart";

class PlayerTile extends StatelessWidget {
  final Player player;
  final VoidCallback onTap;
  final Widget? trailing;

  const PlayerTile({
    super.key,
    required this.player,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        backgroundImage: player.photoUrl.isNotEmpty ? NetworkImage(player.photoUrl) : null,
        child: player.photoUrl.isEmpty
            ? Text(player.name.isNotEmpty ? player.name[0].toUpperCase() : "?")
            : null,
      ),
      title: Text(
        player.name,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      subtitle: Text(
        player.teamName.isNotEmpty ? player.teamName : "No Team",
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
    );
  }
}
