import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippeto/custom_packages/extended_scaffold/src/base.dart';
import 'firebase_options.dart';
import 'package:snippeto/theme_provider.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;
Color seedColor = Color(Colors.blue.value);

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, themeProvider, __) => MaterialApp(
        title: 'Snippeto',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: themeProvider.themeMode,
        home: const HomePage(title: 'Snippeto (EarlyAccess)'),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, required this.title}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ThemeProvider themeProvider;
  late SharedPreferences prefs;
  late String design;
  late String size;
  int cookies = 0;

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      cookies = prefs.getInt("cookies") ?? 1;
    });
  }

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
      if (themeProvider.themeMode == ThemeMode.dark) {
        design = 'Dark';
      } else if (themeProvider.themeMode == ThemeMode.light) {
        design = 'Light';
      } else {
        design = 'System settings';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    themeProvider = Provider.of(context);
    if (cookies == 0) {
      initPrefs();
    }
    initDesign();
  }

  @override
  Widget build(BuildContext context) {
    if (cookies == 1) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.fromLTRB(
                15.0, 5.0, (MediaQuery.of(context).size.width / 2) + 128, 10.0),
            content: const Text(
                "This WebSide uses cookies, if you mind, leave the webSide."),
            duration: const Duration(days: 365),
            action: SnackBarAction(
              label: "Ok",
              onPressed: () {
                prefs.setInt("cookies", 2);
                cookies = 2;
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      });
    }
    return ExtendedScaffold(
      drawerLayout: (scaffoldController) {
        return NavigationDrawer(
          selectedIndex: scaffoldController.drawerIndex,
          onDestinationSelected: (value) {
            scaffoldController.drawerIndex = value;
          },
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 16),
              child: Text(
                "SNIPPETO",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            const NavigationDrawerDestination(
              label: Text("Home"),
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
            ),
            const NavigationDrawerDestination(
              label: Text("Settings"),
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
            ),
          ],
        );
      },
      sideSheet: const SideSheetM3(
          headline: "Hello World",
          detached: true,
          modal: false,
          divider: false),
      child: (scaffoldController) {
        return Scaffold(
          appBar: [
            AppBar(
              automaticallyImplyLeading: true,
              title: const Text("Homepage"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.feedback),
                  onPressed: () {
                    scaffoldController.showSideSheet();
                  },
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
            AppBar(
              automaticallyImplyLeading: true,
              title: const Text("General Options"),
              actions: const [
                IconButton(
                  icon: Icon(Icons.feedback),
                  onPressed: null,
                ),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          ].toList()[scaffoldController.drawerIndex],
          body: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    alignment: AlignmentDirectional.center,
                    padding: const EdgeInsets.symmetric(vertical: 64),
                    margin: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    child: ListTile(
                      title: Text(
                        "Snippeto",
                        style: Theme.of(context).textTheme.displayLarge,
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        "Snippeto offers pre-designed Flutter widgets that you can easily customize and implement. Create advanced components, screens, and functionalities with ease using Snippeto.",
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      isThreeLine: true,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 64),
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                    ),
                  ),
                ],
              ),
            ),
            ListView(
              children: [
                ListTile(
                  title: const Text('Design'),
                  subtitle: Text(design),
                  onTap: () => _showThemeModeDialog(context, themeProvider),
                ),
                const AboutListTile(
                  applicationName: 'Snippeto',
                  applicationVersion: '0.1.0',
                ),
              ],
            ),
          ].toList()[scaffoldController.drawerIndex],
        );
      },
    );
  }
}
