import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EmptyFavorites extends StatelessWidget {
  const EmptyFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star_border, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text('noFavorites'.tr(), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'addFavorites'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
