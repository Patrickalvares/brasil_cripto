import 'package:brasil_cripto/features/coin_detail/coin_detail_view.dart';
import 'package:brasil_cripto/utils/routes.dart';

class CoinDetailRoute implements IRoutes {
  @override
  String get featureAppName => 'coin-detail';

  @override
  void Function() get injectionsRegister => () {};

  @override
  Map<String, WidgetBuildArgs> get routes => {
    AppRoutes.coinDetail.path:
        (_, params) => CoinDetailView(coinId: params is String ? params : ''),
  };
}
