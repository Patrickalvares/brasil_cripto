import 'package:flutter/material.dart';

import 'custom_app_bar.dart';

class BaseScaffold extends StatelessWidget {
  final String title;
  final String drawerSelectedOption;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;

  const BaseScaffold({
    super.key,
    required this.title,
    required this.drawerSelectedOption,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        actions: actions,
      ),
      drawer: AppDrawer(
        selectedOption: drawerSelectedOption,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
} 
