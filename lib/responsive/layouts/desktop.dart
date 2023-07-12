import 'package:flutter/material.dart';
import 'package:snippeto/responsive/pages/homepage.dart';
import 'package:snippeto/responsive/pages/settings.dart';
import 'package:snippeto/responsive/theme_provider.dart';

class DesktopLayout extends StatefulWidget {
  final String title;
  final ThemeProvider themeProvider;
  const DesktopLayout(
      {Key? key, required this.title, required this.themeProvider})
      : super(key: key);

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  late List<Widget> pages;
  int navigationIndex = 0;

  @override
  void initState() {
    super.initState();
    pages = [
      Homepage(title: widget.title),
      Settings(themeProvider: widget.themeProvider),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Card(
            elevation: 1,
            shadowColor: Colors.transparent,
            margin: EdgeInsets.zero,
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: NavigationDrawer(
                elevation: 1,
                selectedIndex: navigationIndex,
                onDestinationSelected: (value) => setState(() {
                  navigationIndex = value;
                }),
                children: [
                  DrawerHeader(
                    child: Text(widget.title,
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  const NavigationDrawerDestination(
                    selectedIcon: Icon(Icons.home),
                    icon: Icon(Icons.home_outlined),
                    label: Text('Homepage'),
                  ),
                  const NavigationDrawerDestination(
                    selectedIcon: Icon(Icons.settings),
                    icon: Icon(Icons.settings_outlined),
                    label: Text('Settings'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: pages[navigationIndex],
          ),
        ],
      ),
    );
  }
}
