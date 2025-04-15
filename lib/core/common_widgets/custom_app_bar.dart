import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/theme_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  
  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
  });
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: actions,
    );
  }
}

class AppDrawer extends StatelessWidget {
  final String selectedOption;
  
  const AppDrawer({
    super.key,
    required this.selectedOption,
  });
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          _buildDrawerBody(context, themeProvider),
        ],
      ),
    );
  }
  
  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
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
                'Brasil Cripto',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Monitor de Criptomoedas',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDrawerBody(BuildContext context, ThemeProvider themeProvider) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildNavigationTile(
            context: context,
            icon: Icons.attach_money,
            title: 'Mercado',
            isSelected: selectedOption == 'Mercado',
            onTap: () => _navigateToScreen(context, 0),
          ),
          _buildNavigationTile(
            context: context,
            icon: Icons.search,
            title: 'Pesquisar',
            isSelected: selectedOption == 'Pesquisar',
            onTap: () => _navigateToScreen(context, 1),
          ),
          _buildNavigationTile(
            context: context,
            icon: Icons.star,
            title: 'Favoritos',
            isSelected: selectedOption == 'Favoritos',
            onTap: () => _navigateToScreen(context, 2),
          ),
          const Divider(),
          _buildThemeSwitcher(context, themeProvider),
          _buildNavigationTile(
            context: context,
            icon: Icons.info_outline,
            title: 'Sobre',
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
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : null,
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
    return ExpansionTile(
      leading: Icon(
        themeProvider.isDarkMode
            ? Icons.dark_mode
            : Icons.light_mode,
      ),
      title: const Text('Tema'),
      children: [
        RadioListTile<ThemeMode>(
          title: const Text('Sistema'),
          value: ThemeMode.system,
          groupValue: themeProvider.themeMode,
          onChanged: (ThemeMode? mode) {
            if (mode != null) {
              themeProvider.setThemeMode(mode);
            }
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Claro'),
          value: ThemeMode.light,
          groupValue: themeProvider.themeMode,
          onChanged: (ThemeMode? mode) {
            if (mode != null) {
              themeProvider.setThemeMode(mode);
            }
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Escuro'),
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
  }
  
  void _navigateToScreen(BuildContext context, int index) {
    Navigator.pop(context);
    
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    
    if ((index == 0 && selectedOption != 'Mercado') ||
        (index == 1 && selectedOption != 'Pesquisar') ||
        (index == 2 && selectedOption != 'Favoritos')) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (route) => false,
        arguments: index,
      );
    }
  }
  
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sobre o Brasil Cripto'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Aplicativo para monitoramento de criptomoedas.'),
              SizedBox(height: 8),
              Text('Versão: 1.0.0'),
              SizedBox(height: 16),
              Text('Desenvolvido com Flutter por @patrickalvares'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
