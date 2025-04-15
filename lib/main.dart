import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'core/common_widgets/app_listenable_builder.dart';
import 'core/services/injections.dart';
import 'core/services/locale_provider.dart';
import 'core/services/theme_provider.dart';
import 'features/home/home_view.dart';

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
    final themeProvider = i<ThemeProvider>();
    final localeProvider = i<LocaleProvider>();

    return AppListenableBuilder(
      listenables: [themeProvider, localeProvider],
      builder: (context, values, child) {
        final themeMode = values[0] as ThemeMode;
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
          themeMode: themeMode,
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
    );
  }
}
