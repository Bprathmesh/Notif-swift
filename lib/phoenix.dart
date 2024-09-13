import 'package:flutter/material.dart';

class Phoenix extends StatefulWidget {
  final Widget child;

  const Phoenix({super.key, required this.child});

  static rebirth(BuildContext context) {
    final _PhoenixState? state = context.findAncestorStateOfType<_PhoenixState>();
    state?.rebuild();
  }

  @override
  _PhoenixState createState() => _PhoenixState();
}

class _PhoenixState extends State<Phoenix> {
  Key _key = UniqueKey();

  void rebuild() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: widget.child,
    );
  }
}