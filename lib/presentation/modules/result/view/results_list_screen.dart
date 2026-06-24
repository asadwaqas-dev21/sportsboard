import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/core/theme/app_colors.dart";
import "package:sportsboard/presentation/global_widgets/loading_widget.dart";
import "package:sportsboard/presentation/modules/result/controller/result_controller.dart";

class ResultsListScreen extends GetView<ResultController> {
  const ResultsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: LoadingWidget());
              }

              if (controller.results.isEmpty) {
                return const Center(
                  child: Text(
                    "No match results available right now.",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: controller.results.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final result = controller.results[index];
                  return _buildSimpleResultCard(
                    context,
                    result.teamAName,
                    result.teamBName,
                    result.scoreSummary,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleResultCard(
    BuildContext context,
    String teamA,
    String teamB,
    String score,
  ) {
    // Attempting to parse score for UI display
    final parts = score.split("-").map((e) => e.trim()).toList();
    final scoreA = parts.isNotEmpty ? parts[0] : "0";
    final scoreB = parts.length > 1 ? parts[1] : "0";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          // Header / Date
          Text(
            "Match Result",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),

          // Teams and Score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Team A
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          teamA.isNotEmpty ? teamA[0].toUpperCase() : "?",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      teamA,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Score
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      "$scoreA - $scoreB",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.accent,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              // Team B
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          teamB.isNotEmpty ? teamB[0].toUpperCase() : "?",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      teamB,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Winner Footer
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "$teamA won this match 🎉",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
