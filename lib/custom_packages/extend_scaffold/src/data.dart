import 'package:flutter/material.dart';
import 'controller.dart';

class ExtendScaffoldData extends InheritedWidget {
  final ExtendScaffoldController controller;
  const ExtendScaffoldData({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(ExtendScaffoldData oldWidget) {
    return oldWidget.controller != controller;
  }
}
