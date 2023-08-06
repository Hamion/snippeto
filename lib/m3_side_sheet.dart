import 'package:flutter/material.dart';

class MaterialSideSheet extends StatefulWidget {
  final bool modal;
  final bool detached;
  final String? title;
  final Widget? sidesheet;
  final Widget child;
  const MaterialSideSheet(
      {Key? key,
      this.modal = true,
      this.detached = false,
      this.title,
      this.sidesheet,
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
  double m = 0;

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
        m = 16;
      });
    }
  }

  void hide() {
    if (visible) {
      setState(() {
        animation.reverse();
        visible = false;
        x = y = m = 0;
      });
    }
  }

  Widget _sideSheet() {
    ThemeData theme = Theme.of(context);
    if (widget.modal) {
      if (widget.detached) {
        return AnimatedContainer(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.only(
            top: 16,
            left: Directionality.of(context) == TextDirection.ltr ? 64 : m,
            right: Directionality.of(context) == TextDirection.ltr ? m : 64,
            bottom: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
          ),
          duration: visible ? enterDuration : exitDuration,
          curve: visible ? easeIn : easeOut,
          constraints: BoxConstraints(
              maxWidth: x, minWidth: y, minHeight: double.maxFinite),
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
                      title: Text(widget.title ?? ""),
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
                    widget.sidesheet ?? const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        return AnimatedContainer(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.only(
            left: Directionality.of(context) == TextDirection.ltr ? 64 : 0,
            right: Directionality.of(context) == TextDirection.ltr ? 0 : 64,
          ),
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
          constraints: BoxConstraints(
              maxWidth: x, minWidth: y, minHeight: double.maxFinite),
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
                      title: Text(widget.title ?? ""),
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
                    widget.sidesheet ?? const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    } else {
      if (widget.detached) {
        return AnimatedContainer(
          clipBehavior: Clip.antiAlias,
          duration: visible ? enterDuration : exitDuration,
          curve: visible ? easeIn : easeOut,
          margin: EdgeInsets.fromLTRB(m, 16, m, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
          ),
          constraints: BoxConstraints(
              maxWidth: x, minWidth: y, minHeight: double.maxFinite),
          child: Material(
            elevation: 0,
            color: ElevationOverlay.applySurfaceTint(
                theme.colorScheme.surface, theme.colorScheme.surfaceTint, 1),
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
                      title: Text(widget.title ?? ""),
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
                    widget.sidesheet ?? const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        return AnimatedContainer(
          duration: visible ? enterDuration : exitDuration,
          curve: visible ? easeIn : easeOut,
          constraints: BoxConstraints(
              maxWidth: x, minWidth: y, minHeight: double.maxFinite),
          child: Material(
            elevation: 0,
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
                      title: Text(widget.title ?? ""),
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
                    widget.sidesheet ?? const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }
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
        : Container(
            color: Theme.of(context).colorScheme.background,
            child: Row(
              children: [
                Expanded(child: widget.child),
                _sideSheet(),
              ],
            ),
          );
  }
}
