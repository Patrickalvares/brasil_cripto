import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/injections.dart';
import 'core/services/locale_provider.dart';
import 'core/services/theme_provider.dart';
import 'features/coin_detail/coin_detail_viewmodel.dart';
import 'features/favorites/favorites_viewmodel.dart';
import 'features/home/home_view.dart';
import 'features/market/market_viewmodel.dart';
import 'features/search/search_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  setupInjections();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
      path: 'assets/translations',
      fallbackLocale: const Locale('pt', 'BR'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => i<MarketViewModel>()),
        ChangeNotifierProvider(create: (_) => i<SearchViewModel>()),
        ChangeNotifierProvider(create: (_) => i<FavoritesViewModel>()),
        ChangeNotifierProvider(create: (_) => i<CoinDetailViewModel>()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          if (context.locale != localeProvider.locale) {
            Future.microtask(() {
              context.setLocale(localeProvider.locale);
            });
          }

          return MaterialApp(
            title: 'appName'.tr(),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
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
            themeMode: themeProvider.themeMode,
            home: const HomeView(),
            onGenerateRoute: (settings) {
              if (settings.name == '/') {
                final index = settings.arguments as int?;
                return MaterialPageRoute(builder: (context) => HomeView(initialIndex: index));
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
