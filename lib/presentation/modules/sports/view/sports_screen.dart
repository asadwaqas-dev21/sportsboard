import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:sportsboard/app/routes/app_routes.dart";
import "package:sportsboard/domain/entities/sport.dart";
import "package:sportsboard/presentation/global_widgets/empty_state.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/global_widgets/sport_list_tile.dart";
import "package:sportsboard/presentation/modules/home/controller/home_controller.dart";

class SportsScreen extends GetView<HomeController> {
  const SportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingSports.value) {
        return const ListLoadingWidget(count: 6, itemHeight: 72);
      }

      if (controller.sports.isEmpty) {
        return const EmptyState(
          title: "No Sports",
          subtitle: "Sports will appear here once added.",
          icon: Iconsax.category,
        );
      }

      final outdoor = controller.sports.where((s) => _isOutdoor(s.name)).toList();
      final indoor = controller.sports.where((s) => !_isOutdoor(s.name)).toList();

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          if (outdoor.isNotEmpty) ...[
            _CategoryLabel("Outdoor"),
            const SizedBox(height: 8),
            ..._tiles(outdoor),
            const SizedBox(height: 20),
          ],
          if (indoor.isNotEmpty) ...[
            _CategoryLabel("Indoor"),
            const SizedBox(height: 8),
            ..._tiles(indoor),
          ],
          const SizedBox(height: 16),
        ],
      );
    });
  }

  List<Widget> _tiles(List<Sport> sports) => [
        for (final sport in sports) ...[
          SportListTile(
            sport: sport,
            onTap: () => Get.toNamed(AppRoutes.sportDetails, arguments: sport),
          ),
          const SizedBox(height: 8),
        ],
      ];

  bool _isOutdoor(String name) {
    final n = name.toLowerCase();
    return n.contains("cricket") ||
        n.contains("football") ||
        n.contains("volleyball") ||
        n.contains("basketball") ||
        n.contains("hockey") ||
        n.contains("athletics") ||
        (n.contains("tennis") && !n.contains("table"));
  }
}

class _CategoryLabel extends StatelessWidget {
  final String text;
  const _CategoryLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            letterSpacing: 1.2,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
    );
  }
}
