import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:snippeto/responsive/layout.dart';
import 'package:snippeto/responsive/layouts/mobile.dart';
import 'package:snippeto/responsive/layouts/tablet.dart';
import 'package:snippeto/responsive/layouts/desktop.dart';
import 'package:snippeto/responsive/theme_provider.dart';

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
  late String size;
  int destinationIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: MobileLayout(title: widget.title),
      tabletLayout: TabletLayout(title: widget.title),
      desktopLayout: DesktopLayout(
          title: widget.title,
          themeProvider: Provider.of<ThemeProvider>(context)),
    );
  }
}
