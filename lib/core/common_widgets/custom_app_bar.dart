import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../services/injections.dart';
import '../services/locale_provider.dart';
import '../services/theme_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({super.key, required this.title, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(title), centerTitle: true, actions: actions);
  }
}

class AppDrawer extends StatelessWidget {
  final String selectedOption;

  const AppDrawer({super.key, required this.selectedOption});

  @override
  Widget build(BuildContext context) {
    final themeProvider = i<ThemeProvider>();
    final localeProvider = i<LocaleProvider>();

    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          _buildDrawerBody(context, themeProvider, localeProvider),
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
  ) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildNavigationTile(
            context: context,
            icon: Icons.attach_money,
            title: 'market'.tr(),
            isSelected: selectedOption == 'market'.tr(),
            onTap: () => _navigateToScreen(context, 0),
          ),
          _buildNavigationTile(
            context: context,
            icon: Icons.search,
            title: 'search'.tr(),
            isSelected: selectedOption == 'search'.tr(),
            onTap: () => _navigateToScreen(context, 1),
          ),
          _buildNavigationTile(
            context: context,
            icon: Icons.star,
            title: 'favorites'.tr(),
            isSelected: selectedOption == 'favorites'.tr(),
            onTap: () => _navigateToScreen(context, 2),
          ),
          const Divider(),
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

  void _navigateToScreen(BuildContext context, int index) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false, arguments: index);
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
