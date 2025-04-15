import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchInitial extends StatelessWidget {
  const SearchInitial({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text('searchCryptos'.tr(), style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
