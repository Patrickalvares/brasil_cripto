import 'package:brasil_cripto/features/search/search_view.dart';
import 'package:brasil_cripto/utils/routes.dart';

class SearchStateRoute implements IRoutes {
  @override
  String get featureAppName => 'search';

  @override
  void Function() get injectionsRegister => () {};

  @override
  Map<String, WidgetBuildArgs> get routes => {
    AppRoutes.searchState.path: (_, __) => const SearchView(),
  };
}
