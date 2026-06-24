import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/global_widgets/section_header.dart";
import "package:sportsboard/presentation/global_widgets/sport_card.dart";
import "package:sportsboard/presentation/modules/home/controller/home_controller.dart";

class SportsGridSection extends GetView<HomeController> {
  const SportsGridSection({super.key});

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
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 4,
                itemBuilder: (context, index) => const LoadingWidget(),
              );
            }

            if (controller.sports.isEmpty) {
              return const SizedBox.shrink();
            }

            final displaySports = controller.sports.take(4).toList();

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: displaySports.length,
              itemBuilder: (context, index) {
                final sport = displaySports[index];
                return SportCard(
                  sport: sport,
                  onTap: () {},
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
