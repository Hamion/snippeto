import 'package:flutter/material.dart';
import 'controller.dart';

class ExtendedScaffoldData extends InheritedWidget {
  final ExtendedScaffoldController controller;
  const ExtendedScaffoldData({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(ExtendedScaffoldData oldWidget) {
    return oldWidget.controller != controller;
  }
}
