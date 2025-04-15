import 'package:flutter/material.dart';

typedef WidgetBuildArgs = Widget Function(BuildContext context, Object? args);

abstract interface class IRoutes {
  String get featureAppName;
  Map<String, WidgetBuildArgs> get routes;
  void Function() get injectionsRegister;
}

enum AppRoutes {
  market(path: '/market');

  const AppRoutes({required this.path});
  final String path;
}
