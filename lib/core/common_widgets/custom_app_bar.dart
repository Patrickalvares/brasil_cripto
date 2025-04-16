import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onDrawerPressed;

  const CustomAppBar({super.key, required this.title, this.actions, this.onDrawerPressed});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: actions,
      leading: IconButton(
        icon: const Icon(Icons.settings),
        onPressed: onDrawerPressed ?? () => Scaffold.of(context).openDrawer(),
      ),
    );
  }
}
