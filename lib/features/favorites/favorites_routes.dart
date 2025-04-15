import 'package:brasil_cripto/features/favorites/favorites_view.dart';
import 'package:brasil_cripto/utils/routes.dart';

class FavoritesRoute implements IRoutes {
  @override
  String get featureAppName => 'Favorites';

  @override
  void Function() get injectionsRegister => () {};

  @override
  Map<String, WidgetBuildArgs> get routes => {
    AppRoutes.favorites.path: (_, __) => const FavoritesView(),
  };
}
