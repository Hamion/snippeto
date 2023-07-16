import 'dart:ui' as ui;
// import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// It is recommended to wrap 'MaterialFeedback()' around 'MyApp()'.
class MaterialFeedback extends StatefulWidget {
  /// It is recommended to use it on 'MyApp()'.
  final Widget child;
  const MaterialFeedback({Key? key, required this.child}) : super(key: key);
  @override
  MaterialFeedbackState createState() => MaterialFeedbackState();

  static MaterialFeedbackState of(BuildContext context) {
    return context.findAncestorStateOfType<MaterialFeedbackState>()!;
  }
}

class MaterialFeedbackState extends State<MaterialFeedback> {
  final GlobalKey _materialFeedbackKey = GlobalKey();
  ui.Image? image;
  int feedbackIndex = 0;

  void show(BuildContext context) {
    RenderRepaintBoundary boundary = _materialFeedbackKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    ui.Image image = boundary.toImageSync(
        pixelRatio: MediaQuery.of(context).devicePixelRatio);
    this.image = image;
    _show(context);
  }

  Widget page0() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Chip(
                label: const Text("Welcome! 👋"),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                side: BorderSide.none,
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.mode_comment_outlined),
                  Text(
                    "Please answer a few\nquestions",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(width: 64, child: Divider()),
                  ),
                  SizedBox(height: 40),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.screenshot_outlined),
                  Text(
                    "Please edit your\nscreenshot",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(width: 64, child: Divider()),
                  ),
                  SizedBox(height: 40),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.send_outlined),
                  Text(
                    "You can give us\nfeedback",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: FilledButton(
                  onPressed: () {},
                  child: const Text("Start now"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28)),
                child: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  centerTitle: true,
                  elevation: 5,
                  title: const Text(
                    "Submit feedback to Hamion",
                  ),
                  titleTextStyle: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              StatefulBuilder(
                builder: (context, setState) {
                  switch (feedbackIndex) {
                    case 0:
                      return page0();
                    default:
                      return const Text("Hello World");
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _materialFeedbackKey,
      child: widget.child,
    );
  }
}
