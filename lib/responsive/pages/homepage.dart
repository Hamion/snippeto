import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:snippeto/custom_packages/extended_scaffold/src/base.dart';
// import 'package:snippeto/feedback_m3.dart';
// import 'package:snippeto/m3_scaffold.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

class Homepage extends StatefulWidget {
  final String title;
  const Homepage({Key? key, required this.title}) : super(key: key);
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late SharedPreferences prefs;
  late SideSheetM3 sideSheetM3;
  int cookies = 0;

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      cookies = prefs.getInt("cookies") ?? 1;
    });
  }

  @override
  void initState() {
    super.initState();
    if (cookies == 0) {
      initPrefs();
    }
    sideSheetM3 = const SideSheetM3(
      headline: "Hello World",
      detached: true,
      modal: false,
    );
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
      sideSheet: sideSheetM3,
      child: (scaffoldController) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.feedback),
                onPressed: () {
                  if (sideSheetM3.modal) {
                    scaffoldController.showSideSheet();
                  } else {
                    setState(() {
                      sideSheetM3 = SideSheetM3(
                        headline: sideSheetM3.headline,
                        modal: true,
                        detached: false,
                      );
                    });
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.feedback),
                onPressed: () {
                  if (sideSheetM3.modal) {
                    setState(() {
                      sideSheetM3 = SideSheetM3(
                        headline: sideSheetM3.headline,
                        modal: false,
                        detached: true,
                      );
                    });
                  } else {
                    scaffoldController.showSideSheet();
                  }
                },
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: SingleChildScrollView(
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 64),
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
