import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget tabletLayout;
  final Widget desktopLayout;

  const ResponsiveLayout({super.key, required this.mobileLayout, required this.tabletLayout, required this.desktopLayout});
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 840) {
          return desktopLayout;
        }
        else if (600 < constraints.maxWidth && constraints.maxWidth < 840) {
          return tabletLayout;
        }
        else {
          return mobileLayout;
        }
      },
    );
  }
}