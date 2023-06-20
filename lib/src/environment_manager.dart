import 'dart:async';

import 'package:flutter/widgets.dart';

typedef EnvironmentBuilder<T> = Widget Function(
  BuildContext context,
  T? environment,
);

typedef EnvChanged<T> = FutureOr<void> Function(T value);

class EnvironmentManager<T> extends StatefulWidget {
  final EnvironmentBuilder<T> builder;
  final EnvChanged<T> onChanged;
  final T? initialData;

  const EnvironmentManager({
    required this.builder,
    required this.onChanged,
    this.initialData,
    Key? key,
  }) : super(key: key);

  @override
  State<EnvironmentManager<T>> createState() => _EnvironmentManagerState<T>();

  static _EnvironmentManagerState<T> _getState<T>(BuildContext context) {
    return context.findAncestorStateOfType<_EnvironmentManagerState<T>>()!;
  }

  static void change<T>(
    BuildContext context,
    T env, {
    bool restart = true,
  }) {
    _getState<T>(context)._change(
      context: context,
      env: env,
      restart: restart,
    );
  }

  static T? current<T>(BuildContext context) {
    return _getState<T>(context)._env;
  }
}

class _EnvironmentManagerState<T> extends State<EnvironmentManager<T>> {
  T? _env;

  void _init() {
    // init env id
    _env = widget.initialData;
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EnvironmentManager<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialData != widget.initialData) {
      _init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _env);
  }

  Future<void> _change({
    required BuildContext context,
    required T env,
    required bool restart,
  }) async {
    _env = env;
    await widget.onChanged(env);

    setState(() {
      if (restart) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    });
  }
}
