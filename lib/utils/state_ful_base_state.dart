import 'package:brasil_cripto/core/services/injections.dart';
import 'package:brasil_cripto/utils/base_notifier.dart';
import 'package:flutter/widgets.dart';

abstract class StatefulBaseState<T extends StatefulWidget, C extends BaseNotifier>
    extends State<T> {
  late final C viewModel = i.get<C>();
}
