import 'dart:ui' as ui;
// import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:side_sheet_material3/side_sheet_material3.dart';

class MaterialFeedback extends StatefulWidget {
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
  String? feedbackMessage;
  late ThemeData theme;

  void show(BuildContext context) {
    theme = Theme.of(context);
    _show(context);
    RenderRepaintBoundary boundary = _materialFeedbackKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    ui.Image image = boundary.toImageSync(
        pixelRatio: MediaQuery.of(context).devicePixelRatio);
    this.image = image;
  }

  Widget page0(StateSetter setter) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Chip(
                label: const Text("Welcome! 👋"),
                labelStyle: theme.textTheme.labelMedium!
                    .copyWith(color: theme.colorScheme.onSurfaceVariant),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                side: BorderSide.none,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.mode_comment_outlined,
                      color: theme.colorScheme.onSurfaceVariant),
                  Text(
                    "Please answer a few\nquestions",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall!
                        .copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              const Column(
                children: [
                  SizedBox(width: 64, child: Divider()),
                  SizedBox(height: 24),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.screenshot_outlined,
                      color: theme.colorScheme.onSurfaceVariant),
                  Text(
                    "Please edit your\nscreenshot",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall!
                        .copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              const Column(
                children: [
                  SizedBox(width: 64, child: Divider()),
                  SizedBox(height: 24),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.send_outlined,
                      color: theme.colorScheme.onSurfaceVariant),
                  Text(
                    "You can give us\nfeedback",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall!
                        .copyWith(color: theme.colorScheme.onSurfaceVariant),
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
                  onPressed: () => setter(() {
                    feedbackIndex++;
                  }),
                  child: const Text("Start now"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget page1(StateSetter setter) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                label: const Text("Great! Let's go... 👍"),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                side: BorderSide.none,
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text("Please describe the problem or your suggestion."),
          ),
          TextFormField(
            autofocus: false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              return (value != null && value.isNotEmpty)
                  ? null
                  : "Can't be empty";
            },
            onChanged: (value) => setter(() {
              feedbackMessage = value.isNotEmpty ? value : null;
            }),
            decoration: const InputDecoration(
              filled: false,
              border: UnderlineInputBorder(),
              labelText: "Tell us how we can improve our product*",
              helperText: "*required",
            ),
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: feedbackMessage != null
                    ? () {
                        setter(() {
                          feedbackIndex = 3;
                        });
                      }
                    : null,
                icon: const Icon(Icons.send_outlined),
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget page3(StateSetter setter) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text("Please describe the problem or your suggestion."),
          ),
          Row(
            children: [
              Chip(
                label: Text(feedbackMessage!),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                side: BorderSide.none,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              OutlinedButton(
                onPressed: feedbackMessage != null ? () {} : null,
                child: const Text("Next"),
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
      // constraints: const BoxConstraints(maxWidth: 400),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28), topRight: Radius.circular(28)),
            child: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                  feedbackMessage = null;
                  feedbackIndex = 0;
                },
              ),
              title: Text(
                "Submit feedback to Hamion",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              centerTitle: true,
              elevation: 5,
            ),
          ),
          StatefulBuilder(
            builder: (context, StateSetter setter) {
              switch (feedbackIndex) {
                case 0:
                  return page0(setter);
                case 1:
                  return page1(setter);
                case 3:
                  return page3(setter);
                default:
                  return const Text("Hello World");
              }
            },
          ),
        ],
      ),
    );
    // showModalSideSheet(
    //   context,
    //   addActions: false,
    //   addDivider: false,
    //   header: "Submit feedback to Hamion",
    //   body: StatefulBuilder(
    //     builder: (context, StateSetter setter) {
    //       switch (feedbackIndex) {
    //         case 0:
    //           return page0(setter);
    //         case 1:
    //           return page1(setter);
    //         default:
    //           return const Text("Hello World");
    //       }
    //     },
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _materialFeedbackKey,
      child: widget.child,
    );
  }
}
