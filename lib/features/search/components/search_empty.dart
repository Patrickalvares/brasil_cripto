import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchEmpty extends StatelessWidget {
  const SearchEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text('noResults'.tr(), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('tryDifferentSearch'.tr(), style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
