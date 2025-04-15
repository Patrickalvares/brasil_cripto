import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppListenableBuilder extends StatelessWidget {
  final List<ValueListenable<dynamic>> listenables;
  final Widget Function(BuildContext context, List<dynamic> values, Widget? child) builder;
  final Widget? child;

  const AppListenableBuilder({
    super.key,
    required this.listenables,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (listenables.isEmpty) {
      return builder(context, [], child);
    }

    if (listenables.length == 1) {
      return ValueListenableBuilder(
        valueListenable: listenables[0],
        builder: (context, value, _) => builder(context, [value], child),
        child: child,
      );
    }

    if (listenables.length == 2) {
      return ValueListenableBuilder(
        valueListenable: listenables[0],
        builder: (context, value1, _) {
          return ValueListenableBuilder(
            valueListenable: listenables[1],
            builder: (context, value2, _) => builder(context, [value1, value2], child),
            child: child,
          );
        },
      );
    }

    return _MultiValueListenableBuilder(listenables: listenables, builder: builder, child: child);
  }
}

class _MultiValueListenableBuilder extends StatefulWidget {
  final List<ValueListenable<dynamic>> listenables;
  final Widget Function(BuildContext context, List<dynamic> values, Widget? child) builder;
  final Widget? child;

  const _MultiValueListenableBuilder({
    required this.listenables,
    required this.builder,
    this.child,
  });

  @override
  State<_MultiValueListenableBuilder> createState() => _MultiValueListenableBuilderState();
}

class _MultiValueListenableBuilderState extends State<_MultiValueListenableBuilder> {
  late List<dynamic> _values;

  @override
  void initState() {
    super.initState();
    _values = List<dynamic>.filled(widget.listenables.length, null);
    _updateValues();

    for (int i = 0; i < widget.listenables.length; i++) {
      widget.listenables[i].addListener(() => _handleValueChanged(i));
    }
  }

  @override
  void didUpdateWidget(_MultiValueListenableBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.listenables != oldWidget.listenables) {
      for (final listenable in oldWidget.listenables) {
        listenable.removeListener(_updateValues);
      }

      _values = List<dynamic>.filled(widget.listenables.length, null);
      _updateValues();

      for (int i = 0; i < widget.listenables.length; i++) {
        widget.listenables[i].addListener(() => _handleValueChanged(i));
      }
    }
  }

  @override
  void dispose() {
    for (final listenable in widget.listenables) {
      listenable.removeListener(_updateValues);
    }
    super.dispose();
  }

  void _handleValueChanged(int index) {
    setState(() {
      _values[index] = widget.listenables[index].value;
    });
  }

  void _updateValues() {
    for (int i = 0; i < widget.listenables.length; i++) {
      _values[i] = widget.listenables[i].value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _values, widget.child);
  }
}
