import 'package:flutter/widgets.dart';

typedef EnvironmentBuilder = Widget Function(
  BuildContext context,
  String? envId,
);

typedef OnEnvChanged = void Function(BuildContext context, String id);

class EnvironmentManager extends StatefulWidget {
  final EnvironmentBuilder builder;
  final ValueChanged<String> onChanged;
  final String? initialId;

  const EnvironmentManager({
    required this.builder,
    required this.onChanged,
    this.initialId,
    Key? key,
  }) : super(key: key);

  @override
  State<EnvironmentManager> createState() => _EnvironmentManagerState();

  static _EnvironmentManagerState _getState(BuildContext context) {
    return context.findAncestorStateOfType<_EnvironmentManagerState>()!;
  }

  static void change(
    BuildContext context,
    String envId, {
    bool restart = true,
  }) {
    _getState(context)._change(context: context, id: envId, restart: restart);
  }

  static String? current(BuildContext context) {
    return _getState(context).env;
  }
}

class _EnvironmentManagerState extends State<EnvironmentManager> {
  String? env;

  void _init() {
    // init env id
    env = widget.initialId;
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EnvironmentManager oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialId != widget.initialId) {
      _init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return widget.builder(context, env);
    });
  }

  void _change({
    required BuildContext context,
    required String id,
    required bool restart,
  }) {
    if (id != env) {
      widget.onChanged(id);
      setState(() => env = id);
    }

    if (restart) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}
