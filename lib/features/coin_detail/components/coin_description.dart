import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CoinDescription extends StatelessWidget {
  final String coinName;
  final String? description;

  const CoinDescription({super.key, required this.coinName, this.description});

  @override
  Widget build(BuildContext context) {
    if (description == null || description!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'about_coin'.tr(namedArgs: {'name': coinName}),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(_cleanDescription(description!), style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  String _cleanDescription(String description) {
    return description
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');
  }
}
