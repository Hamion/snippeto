import 'package:flutter/material.dart';
import 'package:snippeto/responsive/theme_provider.dart';

class Settings extends StatefulWidget {
  final ThemeProvider themeProvider;
  const Settings({super.key, required this.themeProvider});
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late String design;

  void _showThemeModeDialog(BuildContext context, ThemeProvider themeProvider) {
    ThemeMode? selectedThemeMode = themeProvider.themeMode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Select Theme Mode'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<ThemeMode>(
                    title: const Text('Light'),
                    value: ThemeMode.light,
                    groupValue: selectedThemeMode,
                    onChanged: (ThemeMode? value) => setState(() {
                      selectedThemeMode = value;
                    }),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Dark'),
                    value: ThemeMode.dark,
                    groupValue: selectedThemeMode,
                    onChanged: (ThemeMode? value) => setState(() {
                      selectedThemeMode = value;
                    }),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('System settings'),
                    value: ThemeMode.system,
                    groupValue: selectedThemeMode,
                    onChanged: (ThemeMode? value) => setState(() {
                      selectedThemeMode = value;
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    themeProvider.setThemeMode(selectedThemeMode);
                    initDesign();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void initDesign() {
    setState(() {
      if (widget.themeProvider.themeMode == ThemeMode.dark) {
        design = 'Dark';
      } else if (widget.themeProvider.themeMode == ThemeMode.light) {
        design = 'Light';
      } else {
        design = 'System settings';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initDesign();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Design'),
            subtitle: Text(design),
            onTap: () => _showThemeModeDialog(context, widget.themeProvider),
          ),
          const AboutListTile(
            applicationName: 'Snippeto',
            applicationVersion: '0.1.0',
          ),
        ],
      ),
    );
  }
}
