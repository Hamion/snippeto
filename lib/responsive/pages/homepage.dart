import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:snippeto/feedback_m3.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

class Homepage extends StatefulWidget {
  final String title;
  const Homepage({Key? key, required this.title}) : super(key: key);
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late SharedPreferences prefs;
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
                "This Website uses cookies, if you mind, leave the website."),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.feedback),
            onPressed: () {
              MaterialFeedback.of(context).show(context);
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
              margin: const EdgeInsets.all(16),
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
  }
}
