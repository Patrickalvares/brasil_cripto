import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CryptoSearchBar extends StatefulWidget {
  final String initialQuery;
  final Function(String) onSearch;
  final VoidCallback onClear;

  const CryptoSearchBar({
    super.key,
    this.initialQuery = '',
    required this.onSearch,
    required this.onClear,
  });

  @override
  State<CryptoSearchBar> createState() => _CryptoSearchBarState();
}

class _CryptoSearchBarState extends State<CryptoSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SearchBar(
        controller: _controller,
        hintText: 'searchHint'.tr(),
        leading: const Icon(Icons.search),
        trailing:
            _controller.text.isNotEmpty
                ? [
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      widget.onClear();
                    },
                  ),
                ]
                : null,
        onSubmitted: (value) {
          widget.onSearch(value);
        },
        onChanged: (value) {
          setState(() {});
          if (value.isEmpty) {
            widget.onClear();
          }
        },
      ),
    );
  }
}
