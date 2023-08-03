import 'package:flutter/material.dart';

class MaterialSideSheet extends StatefulWidget {
  final bool modal;
  final Widget sidesheet;
  final Widget child;
  const MaterialSideSheet(
      {Key? key,
      this.modal = true,
      required this.sidesheet,
      required this.child})
      : super(key: key);
  @override
  MaterialSideSheetState createState() => MaterialSideSheetState();
  static MaterialSideSheetState of(BuildContext context) {
    return context.findAncestorStateOfType<MaterialSideSheetState>()!;
  }
}

class MaterialSideSheetState extends State<MaterialSideSheet>
    with TickerProviderStateMixin {
  late AnimationController animation;
  Duration enterDuration = const Duration(milliseconds: 400);
  Duration exitDuration = const Duration(milliseconds: 200);
  Curve easeIn = const Cubic(0.05, 0.7, 0.1, 1);
  Curve easeOut = const Cubic(0.3, 0, 0.8, 0.15);
  bool visible = false;
  double x = 0;
  double y = 0;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: enterDuration,
      reverseDuration: exitDuration,
    );
  }

  void show() {
    if (!visible) {
      setState(() {
        animation.forward();
        visible = true;
        x = 400;
        y = 256;
      });
    }
  }

  void hide() {
    if (visible) {
      setState(() {
        animation.reverse();
        visible = false;
        x = y = 0;
      });
    }
  }

  Widget _sideSheet() {
    ThemeData theme = Theme.of(context);
    return AnimatedContainer(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: Directionality.of(context) == TextDirection.ltr
              ? const Radius.circular(28)
              : Radius.zero,
          right: Directionality.of(context) == TextDirection.ltr
              ? Radius.zero
              : const Radius.circular(28),
        ),
      ),
      duration: visible ? enterDuration : exitDuration,
      curve: visible ? easeIn : easeOut,
      constraints:
          BoxConstraints(maxWidth: x, minWidth: y, minHeight: double.maxFinite),
      child: Material(
        elevation: 1,
        color: theme.colorScheme.surface,
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: easeIn,
            reverseCurve: easeOut,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  titleSpacing: 0,
                  title: const Text("Hello World"),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        hide();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                widget.sidesheet,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.modal
        ? Stack(
            children: [
              widget.child,
              visible
                  ? FadeTransition(
                      opacity: CurvedAnimation(
                        parent: animation,
                        curve: easeIn,
                        reverseCurve: easeOut,
                      ),
                      child: ModalBarrier(
                        dismissible: false,
                        color: Theme.of(context).colorScheme.scrim.withOpacity(
                            Theme.of(context).brightness == Brightness.dark
                                ? 0.4
                                : 0.2),
                      ),
                    )
                  : const SizedBox(),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: _sideSheet(),
              ),
            ],
          )
        : widget.child;
  }
}
