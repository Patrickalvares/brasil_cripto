import 'package:get_it/get_it.dart';

import '../../data/datasources/coin_data_source.dart';
import '../../data/repositories/coin_repository_impl.dart';
import '../../domain/repositories/coin_repository.dart';
import '../../features/coin_detail/coin_detail_viewmodel.dart';
import '../../features/favorites/favorites_viewmodel.dart';
import '../../features/market/market_viewmodel.dart';
import '../../features/search/search_viewmodel.dart';
import 'api_service.dart';
import 'locale_provider.dart';
import 'storage_service.dart';
import 'theme_provider.dart';

final GetIt i = GetIt.instance;

void setupInjections() {
  // Services
  i.registerLazySingleton<ApiService>(() => ApiService());
  i.registerLazySingleton<StorageService>(() => StorageService());

  // Providers
  i.registerLazySingleton<ThemeProvider>(() => ThemeProvider());
  i.registerLazySingleton<LocaleProvider>(() => LocaleProvider());

  // Data sources
  i.registerLazySingleton<CoinDataSource>(() => CoinDataSourceImpl(i<ApiService>()));

  // Repositories
  i.registerLazySingleton<CoinRepository>(
    () => CoinRepositoryImpl(i<CoinDataSource>(), i<StorageService>()),
  );

  // ViewModels
  i.registerFactory<MarketViewModel>(() => MarketViewModel(i<CoinRepository>()));

  i.registerFactory<CoinDetailViewModel>(() => CoinDetailViewModel(i<CoinRepository>()));

  i.registerFactory<FavoritesViewModel>(() => FavoritesViewModel(i<CoinRepository>()));

  i.registerFactory<SearchViewModel>(() => SearchViewModel(i<CoinRepository>()));
}
