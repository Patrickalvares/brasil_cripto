import 'package:flutter/material.dart';

import '../../core/common_widgets/base_scaffold.dart';
import '../favorites/favorites_view.dart';
import '../market/market_view.dart';
import '../search/search_view.dart';

class HomeView extends StatefulWidget {
  final int? initialIndex;
  
  const HomeView({
    super.key, 
    this.initialIndex,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late int _selectedIndex;
  
  final List<String> _titles = const [
    'Mercado',
    'Pesquisar',
    'Favoritos',
  ];

  final List<Widget> _screens = const [
    MarketView(),
    SearchView(),
    FavoritesView(),
  ];
  
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: _titles[_selectedIndex],
      drawerSelectedOption: _titles[_selectedIndex],
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.attach_money),
            label: 'Mercado',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Pesquisar',
          ),
          NavigationDestination(
            icon: Icon(Icons.star),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
} 
