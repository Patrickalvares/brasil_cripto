import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/injections.dart';
import 'features/coin_detail/coin_detail_viewmodel.dart';
import 'features/favorites/favorites_viewmodel.dart';
import 'features/home/home_view.dart';
import 'features/market/market_viewmodel.dart';
import 'features/search/search_viewmodel.dart';

void main() {

  setupInjections();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => i<MarketViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => i<SearchViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => i<FavoritesViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => i<CoinDetailViewModel>(),
        ),
      ],
      child: MaterialApp(
        title: 'Brasil Cripto',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const HomeView(),
      ),
    );
  }
}
