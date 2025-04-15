import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serviço para gerenciar o estado de onboarding do aplicativo
class OnboardingService extends ChangeNotifier {
  static const String _firstLaunchKey = 'is_first_launch';

  bool _isFirstLaunch = true;
  bool get isFirstLaunch => _isFirstLaunch;

  /// Construtor que inicializa o serviço verificando se é a primeira execução
  OnboardingService() {
    _checkFirstLaunch();
  }

  /// Verifica se é a primeira vez que o aplicativo está sendo executado
  Future<void> _checkFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Se a chave não existir, é a primeira execução
      _isFirstLaunch = !prefs.containsKey(_firstLaunchKey);

      notifyListeners();
    } catch (e) {
      // Em caso de erro, assumimos que é a primeira execução
      _isFirstLaunch = true;
      notifyListeners();
    }
  }

  /// Marca que o onboarding foi completado
  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_firstLaunchKey, true);

      _isFirstLaunch = false;
      notifyListeners();
    } catch (e) {
      // Em caso de erro, ainda consideramos como completado em memória
      _isFirstLaunch = false;
      notifyListeners();
    }
  }

  /// Reseta o estado de onboarding (para testes)
  Future<void> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_firstLaunchKey);

      _isFirstLaunch = true;
      notifyListeners();
    } catch (e) {
      // Ignora erros ao resetar
    }
  }
}
