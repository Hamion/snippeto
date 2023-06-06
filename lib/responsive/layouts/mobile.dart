import 'package:flutter/material.dart';

class MobileLayout extends StatefulWidget {
  final String title;
  const MobileLayout({Key? key, required this.title}) : super(key: key);

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Text(
            'To use this site, go to\nSnippeto on your desktop',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
    );
  }
}
