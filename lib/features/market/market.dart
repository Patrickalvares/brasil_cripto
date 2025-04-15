import 'package:brasil_cripto/features/market/market_view.dart';
import 'package:brasil_cripto/utils/routes.dart';

class MarketRoute implements IRoutes {
  @override
  String get featureAppName => 'Market';

  @override
  void Function() get injectionsRegister => () {};

  @override
  Map<String, WidgetBuildArgs> get routes => {AppRoutes.market.path: (_, __) => const MarketView()};
}
