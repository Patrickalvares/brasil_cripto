import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CoinHeader extends StatelessWidget {
  final String name;
  final String symbol;
  final String? imageUrl;

  const CoinHeader({super.key, required this.name, required this.symbol, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (imageUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: SizedBox(
              width: 50,
              height: 50,
              child: CachedNetworkImage(
                imageUrl: imageUrl!,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                symbol.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
