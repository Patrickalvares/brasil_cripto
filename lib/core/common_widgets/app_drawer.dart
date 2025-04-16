import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../services/currency_provider.dart';
import '../services/injections.dart';
import '../services/locale_provider.dart';
import '../services/theme_provider.dart';

class AppDrawer extends StatelessWidget {
  final String selectedOption;

  const AppDrawer({super.key, required this.selectedOption});

  @override
  Widget build(BuildContext context) {
    final themeProvider = i<ThemeProvider>();
    final localeProvider = i<LocaleProvider>();
    final currencyProvider = i<CurrencyProvider>();

    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          _buildDrawerBody(context, themeProvider, localeProvider, currencyProvider),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.currency_bitcoin,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 32,
              ),
              const SizedBox(width: 16),
              Text(
                'appName'.tr(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'appDescription'.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerBody(
    BuildContext context,
    ThemeProvider themeProvider,
    LocaleProvider localeProvider,
    CurrencyProvider currencyProvider,
  ) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildCurrencySwitcher(context, currencyProvider),
          _buildThemeSwitcher(context, themeProvider),
          _buildLanguageSwitcher(context, localeProvider),
          _buildNavigationTile(
            context: context,
            icon: Icons.info_outline,
            title: 'about'.tr(),
            isSelected: false,
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencySwitcher(BuildContext context, CurrencyProvider currencyProvider) {
    return ValueListenableBuilder(
      valueListenable: currencyProvider,
      builder: (_, __, ___) {
        return ExpansionTile(
          leading: const Icon(Icons.attach_money),
          title: Text('base_currency'.tr()),
          children: [
            RadioListTile<String>(
              title: Text('brazilian_real'.tr()),
              value: 'brl',
              groupValue: currencyProvider.currency,
              onChanged: (String? currency) {
                if (currency != null) {
                  currencyProvider.setCurrency(currency);
                }
              },
            ),
            RadioListTile<String>(
              title: Text('american_dollar'.tr()),
              value: 'usd',
              groupValue: currencyProvider.currency,
              onChanged: (String? currency) {
                if (currency != null) {
                  currencyProvider.setCurrency(currency);
                }
              },
            ),
            RadioListTile<String>(
              title: Text('euro'.tr()),
              value: 'eur',
              groupValue: currencyProvider.currency,
              onChanged: (String? currency) {
                if (currency != null) {
                  currencyProvider.setCurrency(currency);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildNavigationTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : null),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  Widget _buildThemeSwitcher(BuildContext context, ThemeProvider themeProvider) {
    return ValueListenableBuilder(
      valueListenable: themeProvider,
      builder: (_, themeMode, __) {
        return ExpansionTile(
          leading: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
          title: Text('theme'.tr()),
          children: [
            RadioListTile<ThemeMode>(
              title: Text('systemTheme'.tr()),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? mode) {
                if (mode != null) {
                  themeProvider.setThemeMode(mode);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text('lightTheme'.tr()),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? mode) {
                if (mode != null) {
                  themeProvider.setThemeMode(mode);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text('darkTheme'.tr()),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? mode) {
                if (mode != null) {
                  themeProvider.setThemeMode(mode);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageSwitcher(BuildContext context, LocaleProvider localeProvider) {
    return ValueListenableBuilder(
      valueListenable: localeProvider,
      builder: (_, locale, __) {
        return ExpansionTile(
          leading: const Icon(Icons.language),
          title: Text('language'.tr()),
          children: [
            RadioListTile<Locale>(
              title: Text('portuguese'.tr()),
              value: const Locale('pt', 'BR'),
              groupValue: localeProvider.locale,
              onChanged: (Locale? locale) {
                if (locale != null) {
                  localeProvider.setLocale(locale);
                  context.setLocale(locale);
                }
              },
            ),
            RadioListTile<Locale>(
              title: Text('english'.tr()),
              value: const Locale('en', 'US'),
              groupValue: localeProvider.locale,
              onChanged: (Locale? locale) {
                if (locale != null) {
                  localeProvider.setLocale(locale);
                  context.setLocale(locale);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('aboutAppTitle'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('aboutAppDescription'.tr()),
              const SizedBox(height: 8),
              Text('version'.tr()),
              const SizedBox(height: 16),
              Text('developedWith'.tr()),
            ],
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('close'.tr()))],
        );
      },
    );
  }
}
