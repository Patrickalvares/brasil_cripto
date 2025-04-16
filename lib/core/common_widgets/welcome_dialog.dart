// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/currency_provider.dart';
import '../services/injections.dart';
import '../services/locale_provider.dart';
import '../services/onboarding_service.dart';
import '../services/theme_provider.dart';

class WelcomeDialog extends StatefulWidget {
  const WelcomeDialog({super.key});

  static Future<void> showIfNeeded(BuildContext context) async {
    final onboardingService = i<OnboardingService>();

    await Future.delayed(const Duration(milliseconds: 200));

    if (onboardingService.isFirstLaunch) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const WelcomeDialog(),
      );
    }
  }

  @override
  State<WelcomeDialog> createState() => _WelcomeDialogState();
}

class _WelcomeDialogState extends State<WelcomeDialog> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final _themeProvider = i<ThemeProvider>();
  final _localeProvider = i<LocaleProvider>();
  final _currencyProvider = i<CurrencyProvider>();
  final _onboardingService = i<OnboardingService>();

  ThemeMode _selectedTheme = ThemeMode.dark;
  Locale _selectedLocale = const Locale('pt', 'BR');
  String _selectedCurrency = 'usd';

  @override
  void initState() {
    super.initState();
    _selectedTheme = _themeProvider.themeMode;
    _selectedLocale = _localeProvider.locale;
    _selectedCurrency = _currencyProvider.currency;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _saveSettings() async {
    await _themeProvider.setThemeMode(_selectedTheme);
    await _localeProvider.setLocale(_selectedLocale, null);
    await _currencyProvider.setCurrency(_selectedCurrency);

    await _onboardingService.completeOnboarding();

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _saveSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildLanguagePage(),
                  _buildWelcomePage(),
                  _buildThemePage(),
                  _buildCurrencyPage(),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  TextButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text('back'.tr()),
                  )
                else
                  TextButton(
                    onPressed: () {
                      _saveSettings();
                    },
                    child: Text('later'.tr()),
                  ),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(_currentPage == 3 ? 'confirm'.tr() : 'continue'.tr()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.currency_bitcoin, size: 80, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 24),
        Text(
          'welcome_title'.tr(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'welcome_description'.tr(),
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildThemePage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'theme'.tr(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'choose_preferences'.tr(),
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        _buildThemeOption(ThemeMode.dark, 'darkTheme'.tr(), Icons.dark_mode),
        _buildThemeOption(ThemeMode.light, 'lightTheme'.tr(), Icons.light_mode),
        _buildThemeOption(ThemeMode.system, 'systemTheme'.tr(), Icons.smartphone),
      ],
    );
  }

  Widget _buildLanguagePage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'language'.tr(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'choose_preferences'.tr(),
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        _buildLanguageOption(const Locale('pt', 'BR'), 'portuguese'.tr(), '🇧🇷'),
        _buildLanguageOption(const Locale('en', 'US'), 'english'.tr(), '🇺🇸'),
      ],
    );
  }

  Widget _buildCurrencyPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'base_currency'.tr(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'currency_description'.tr(),
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        _buildCurrencyOption('usd', 'american_dollar'.tr()),
        _buildCurrencyOption('brl', 'brazilian_real'.tr()),
        _buildCurrencyOption('eur', 'euro'.tr()),
      ],
    );
  }

  Widget _buildThemeOption(ThemeMode themeMode, String title, IconData icon) {
    final isSelected = _selectedTheme == themeMode;
    return RadioListTile<ThemeMode>(
      title: Row(
        children: [
          Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : null),
          const SizedBox(width: 16),
          Text(title),
        ],
      ),
      value: themeMode,
      groupValue: _selectedTheme,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedTheme = value;
          });
          _themeProvider.setThemeMode(value);
        }
      },
    );
  }

  Widget _buildLanguageOption(Locale locale, String title, String flag) {
    return RadioListTile<Locale>(
      title: Row(
        children: [
          Text(flag, style: TextStyle(fontSize: 24.sp)),
          const SizedBox(width: 16),
          Text(title, style: TextStyle(fontSize: 16.sp)),
        ],
      ),
      value: locale,
      groupValue: _selectedLocale,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedLocale = value;
          });
          _localeProvider.setLocale(value, null);
          context.setLocale(value);
        }
      },
    );
  }

  Widget _buildCurrencyOption(String currency, String title) {
    return RadioListTile<String>(
      title: Row(children: [Text(title, style: TextStyle(fontSize: 16.sp))]),
      value: currency,
      groupValue: _selectedCurrency,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedCurrency = value;
          });
        }
      },
    );
  }
}
