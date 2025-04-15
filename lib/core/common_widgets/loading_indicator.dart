import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CoinLoadingIndicator extends StatelessWidget {
  final int itemCount;

  const CoinLoadingIndicator({super.key, this.itemCount = 10});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
      itemBuilder: (context, index) {
        return _buildShimmerItem(context);
      },
    );
  }

  Widget _buildShimmerItem(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade600,
      highlightColor: Colors.grey.shade400,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 100, height: 14, color: Colors.white),
                  const SizedBox(height: 4),
                  Container(width: 60, height: 12, color: Colors.white),
                ],
              ),
            ),

            Container(width: 60, height: 30, color: Colors.white),

            const SizedBox(width: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(width: 70, height: 14, color: Colors.white),
                const SizedBox(height: 4),
                Container(width: 40, height: 12, color: Colors.white),
              ],
            ),

            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}
