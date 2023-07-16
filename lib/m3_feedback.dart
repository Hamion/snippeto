import 'package:flutter/material.dart';

import 'package:screenshot/screenshot.dart';

GlobalKey screenshotKey = GlobalKey();
ScreenshotController screenshotController = ScreenshotController();

class BottomSheetFeedback {
  void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28), topRight: Radius.circular(28)),
            child: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                "Submit feedback to Hamion",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              centerTitle: true,
              elevation: 5,
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Center(
              child: FutureBuilder(
                future: screenshotController.capture(),
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  return (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData)
                      ? Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                          color: Theme.of(context)
                              .colorScheme
                              .scrim
                              .withOpacity(.25),
                          colorBlendMode: BlendMode.multiply,
                        )
                      : const CircularProgressIndicator();
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      "Please describe the problem or your suggestion.",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  subtitle: TextFormField(
                    autofocus: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return (value != null && value.isNotEmpty)
                          ? null
                          : "Can't be empty";
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      border: UnderlineInputBorder(),
                      labelText: "Tell us how we can improve our product*",
                      helperText: "*required",
                    ),
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackScreenshotContainer extends StatefulWidget {
  final Widget child;
  const FeedbackScreenshotContainer({Key? key, required this.child})
      : super(key: key);
  @override
  State<FeedbackScreenshotContainer> createState() =>
      _FeedbackScreenshotContainerState();
}

class _FeedbackScreenshotContainerState
    extends State<FeedbackScreenshotContainer> {
  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: widget.child,
    );
  }
}
