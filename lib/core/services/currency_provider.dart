import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider para gerenciar a moeda base utilizada na exibição dos preços.
class CurrencyProvider extends ChangeNotifier implements ValueListenable<String> {
  static const String _prefsKey = 'selected_currency';

  String _currency = 'brl'; // Valor padrão: Real brasileiro

  @override
  String get value => _currency;

  String get currency => _currency;

  /// Mapa com as moedas disponíveis e seus símbolos
  static const Map<String, String> availableCurrencies = {
    'usd': '\$', // Dólar americano
    'brl': 'R\$', // Real brasileiro
    'eur': '€', // Euro
  };

  /// Obtém o símbolo da moeda atual
  String get currencySymbol => availableCurrencies[_currency] ?? '\$';

  /// Construtor que carrega a moeda salva nas preferências
  CurrencyProvider() {
    _loadSavedCurrency();
  }

  /// Carrega a moeda salva nas preferências
  Future<void> _loadSavedCurrency() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCurrency = prefs.getString(_prefsKey);

      if (savedCurrency != null && availableCurrencies.containsKey(savedCurrency)) {
        _currency = savedCurrency;
        notifyListeners();
      }
    } catch (e) {
      // Em caso de erro, mantém a moeda padrão
    }
  }

  /// Define a moeda a ser utilizada
  Future<void> setCurrency(String currency) async {
    if (!availableCurrencies.containsKey(currency)) {
      return;
    }

    _currency = currency;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, currency);
    } catch (e) {
      // Erro ao salvar, mas mantém o valor em memória
    }

    notifyListeners();
  }

  /// Formata um valor para a moeda atual
  String formatCurrency(num value) {
    if (value == 0) return '${currencySymbol}0.00';

    final formattedValue =
        value < 1 && value > 0
            ? value.toStringAsFixed(6) // Mais casas decimais para valores muito pequenos
            : value.toStringAsFixed(2); // 2 casas decimais para valores normais

    return '$currencySymbol$formattedValue';
  }
}
