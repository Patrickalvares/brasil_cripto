import 'package:flutter/material.dart';

import '../market_viewmodel.dart';

class MarketScrollController {
  final ScrollController scrollController = ScrollController();
  final MarketViewModel viewModel;

  MarketScrollController(this.viewModel);

  void dispose() {
    scrollController.dispose();
  }
}
