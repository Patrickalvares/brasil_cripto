import 'package:flutter/material.dart';

import '../../../core/common_widgets/search_bar_widget.dart';
import '../search_viewmodel.dart';

class SearchBarContainer extends StatelessWidget {
  final String initialQuery;
  final SearchViewModel viewModel;

  const SearchBarContainer({super.key, required this.initialQuery, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return CryptoSearchBar(
      initialQuery: initialQuery,
      onSearch: (query) {
        viewModel.pesquisarMoedas(query);
      },
      onClear: () {
        viewModel.limparPesquisa();
      },
    );
  }
}
