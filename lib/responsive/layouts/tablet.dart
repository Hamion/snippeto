import 'package:flutter/material.dart';

class TabletLayout extends StatefulWidget {
  final String title;
  const TabletLayout({Key? key, required this.title}) : super(key: key);

  @override
  State<TabletLayout> createState() => _TabletLayoutState();
}

class _TabletLayoutState extends State<TabletLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Text(
            'To use this site, go to\nSnippeto on your desktop',
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
      ),
    );
  }
}
