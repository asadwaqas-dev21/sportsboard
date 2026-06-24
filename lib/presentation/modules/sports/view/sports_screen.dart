import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/app/routes/app_routes.dart";
import "package:sportsboard/core/theme/app_colors.dart";
import "package:sportsboard/domain/entities/sport.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/modules/home/controller/home_controller.dart";

class SportsScreen extends GetView<HomeController> {
  const SportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildSegmentedControl(),
          Expanded(
            child: Obx(() {
              if (controller.isLoadingSports.value) {
                return const Center(child: LoadingWidget());
              }

              if (controller.sports.isEmpty) {
                return const Center(child: Text("No sports available"));
              }

              // Mock categorization for UI demonstration based on design
              final outdoorSports = controller.sports
                  .where((s) => _isOutdoor(s.name))
                  .toList();
              final indoorSports = controller.sports
                  .where((s) => !_isOutdoor(s.name))
                  .toList();

              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                children: [
                  if (outdoorSports.isNotEmpty) ...[
                    _buildSectionTitle("Outdoor Games"),
                    const SizedBox(height: 16),
                    _buildSportsList(outdoorSports),
                    const SizedBox(height: 24),
                  ],
                  if (indoorSports.isNotEmpty) ...[
                    _buildSectionTitle("Indoor Games"),
                    const SizedBox(height: 16),
                    _buildSportsList(indoorSports),
                    const SizedBox(height: 24),
                  ],
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  bool _isOutdoor(String name) {
    final lower = name.toLowerCase();
    return lower.contains("cricket") ||
        lower.contains("football") ||
        lower.contains("volleyball") ||
        lower.contains("basketball") ||
        lower.contains("hockey") ||
        lower.contains("athletics") ||
        lower.contains("tennis") && !lower.contains("table");
  }

  Widget _buildSegmentedControl() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSegment("All Sports", true),
          _buildSegment("Outdoor", false),
          _buildSegment("Indoor", false),
        ],
      ),
    );
  }

  Widget _buildSegment(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF6C38FF)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[600],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSportsList(List<Sport> sports) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sports.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final sport = sports[index];
        return _buildSportCard(sport);
      },
    );
  }

  Widget _buildSportCard(Sport sport) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.sportDetails, arguments: sport);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sports_baseball,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sport.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "1 Tournament", // Mock data
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
