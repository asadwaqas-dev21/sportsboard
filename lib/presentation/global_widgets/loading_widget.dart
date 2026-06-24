import "package:flutter/material.dart";
import "package:shimmer/shimmer.dart";

class LoadingWidget extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry margin;

  const LoadingWidget({
    super.key,
    this.width = double.infinity,
    this.height = 100,
    this.borderRadius = 12,
    this.margin = const EdgeInsets.only(bottom: 12),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        margin: margin,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ListLoadingWidget extends StatelessWidget {
  final int count;
  final double itemHeight;

  const ListLoadingWidget({
    super.key,
    this.count = 5,
    this.itemHeight = 100,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return LoadingWidget(height: itemHeight);
      },
    );
  }
}
