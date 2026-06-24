import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/app/routes/app_routes.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/global_widgets/section_header.dart";
import "package:sportsboard/presentation/global_widgets/sport_list_tile.dart";
import "package:sportsboard/presentation/modules/home/controller/home_controller.dart";

class SportsListSection extends GetView<HomeController> {
  const SportsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: "Sports Categories",
            onSeeAll: () => controller.changePage(1),
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.isLoadingSports.value) {
              return const ListLoadingWidget(count: 3, itemHeight: 72);
            }

            if (controller.sports.isEmpty) {
              return const SizedBox.shrink();
            }

            final displaySports = controller.sports.take(4).toList();

            return Column(
              children: [
                for (final sport in displaySports) ...[
                  SportListTile(
                    sport: sport,
                    onTap: () => Get.toNamed(AppRoutes.sportDetails, arguments: sport),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }
}
