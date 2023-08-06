import 'package:flutter/material.dart';

import 'controller.dart';
import 'data.dart';

typedef ScaffoldBuilder = Scaffold Function(
    ExtendedScaffoldController scaffoldController);

class SiteSheetM3 extends StatelessWidget {
  final bool modal;
  final bool detached;
  final String headline;
  final Widget child;

  const SiteSheetM3({
    super.key,
    this.modal = true,
    this.detached = false,
    this.headline = "",
    this.child = const SizedBox(),
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class ExtendedScaffold extends StatefulWidget {
  final SiteSheetM3? siteSheet;
  final ScaffoldBuilder child;

  const ExtendedScaffold({
    super.key,
    this.siteSheet,
    required this.child,
  });

  @override
  State<ExtendedScaffold> createState() => _ExtendedScaffoldState();

  static ExtendedScaffoldController of(BuildContext context) {
    final sideSheetData =
        context.dependOnInheritedWidgetOfExactType<ExtendedScaffoldData>();
    assert(sideSheetData != null,
        'You need to add a $ExtendedScaffold widget above this context!');
    return sideSheetData!.controller;
  }
}

class _ExtendedScaffoldState extends State<ExtendedScaffold>
    with TickerProviderStateMixin {
  Duration enterDuration = const Duration(milliseconds: 400);
  Duration exitDuration = const Duration(milliseconds: 200);
  Curve easeIn = const Cubic(0.05, 0.7, 0.1, 1);
  Curve easeOut = const Cubic(0.3, 0, 0.8, 0.15);
  late AnimationController animation;
  bool visible = false;
  double x = 0;
  double y = 0;
  double m = 0;
  ExtendedScaffoldController scaffoldController = ExtendedScaffoldController();

  void _showSideSheet() {
    setState(() {
      animation.forward();
      visible = true;
      x = 400;
      y = 256;
      m = 16;
    });
  }

  void _hideSideSheet() {
    setState(() {
      animation.reverse();
      visible = false;
      x = y = m = 0;
    });
  }

  void onControllerChanged() {
    if (scaffoldController.sideSheetVisible) {
      _showSideSheet();
    } else {
      _hideSideSheet();
    }
  }

  @override
  void initState() {
    super.initState();
    scaffoldController.addListener(onControllerChanged);
    animation = AnimationController(
      vsync: this,
      duration: enterDuration,
      reverseDuration: exitDuration,
    );
  }

  @override
  void dispose() {
    scaffoldController.dispose();
    animation.dispose();
    super.dispose();
  }

  Widget _sideSheet() {
    SiteSheetM3 siteSheet = widget.siteSheet!;
    bool ltr = Directionality.of(context) == TextDirection.ltr;
    BorderRadius? borderRadius;
    EdgeInsets? margin;
    Border? verticalDivider;
    double elevation = 1;

    if (siteSheet.modal) {
      if (siteSheet.detached) {
        margin = EdgeInsets.fromLTRB(ltr ? 64 : m, 16, ltr ? m : 64, 16);
        borderRadius = BorderRadius.circular(28);
      } else {
        margin = EdgeInsets.only(left: ltr ? 64 : 0, right: ltr ? 0 : 64);
        borderRadius = ltr
            ? const BorderRadius.horizontal(left: Radius.circular(28))
            : const BorderRadius.horizontal(right: Radius.circular(28));
      }
    } else {
      if (siteSheet.detached) {
        margin = ltr
            ? EdgeInsets.fromLTRB(0, 0, m, 16)
            : EdgeInsets.fromLTRB(m, 0, 0, 16);
        borderRadius = BorderRadius.circular(28);
      } else {
        elevation = 0;
        margin = EdgeInsets.zero;
        borderRadius = BorderRadius.zero;
        verticalDivider = ltr
            ? Border(
                left: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              )
            : Border(
                right: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              );
      }
    }

    return AnimatedContainer(
      duration: visible ? enterDuration : exitDuration,
      curve: visible ? easeIn : easeOut,
      margin: margin,
      constraints:
          BoxConstraints(maxWidth: x, minWidth: y, minHeight: double.maxFinite),
      clipBehavior:
          (siteSheet.modal || siteSheet.detached) ? Clip.antiAlias : Clip.none,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
      ),
      child: Material(
        type: MaterialType.canvas,
        color: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        elevation: elevation,
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: easeIn,
            reverseCurve: easeOut,
          ),
          child: Container(
            decoration: BoxDecoration(border: verticalDivider),
            child: Padding(
              padding: Directionality.of(context) == TextDirection.ltr
                  ? const EdgeInsets.fromLTRB(16, 8, 24, 24)
                  : const EdgeInsets.fromLTRB(24, 8, 16, 24),
              child: Column(
                children: [
                  AppBar(
                    forceMaterialTransparency: true,
                    automaticallyImplyLeading: false,
                    title: Text(siteSheet.headline),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          scaffoldController.hideSideSheet();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.siteSheet != null) {
      if (widget.siteSheet!.modal) {
        return Stack(
          children: [
            widget.child(scaffoldController),
            visible
                ? FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: easeIn,
                    ),
                    child: ModalBarrier(
                      dismissible: true,
                      onDismiss: () {
                        scaffoldController.hideSideSheet();
                      },
                      color: Theme.of(context).colorScheme.scrim.withOpacity(
                          Theme.of(context).brightness == Brightness.dark
                              ? 0.4
                              : 0.2),
                    ),
                  )
                : FutureBuilder(
                    future: animation.reverse().then((value) => true),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData &&
                          snapshot.data! == true) {
                        return const SizedBox();
                      } else {
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            parent: animation,
                            curve: easeIn,
                            reverseCurve: easeOut,
                          ),
                          child: ModalBarrier(
                            dismissible: true,
                            onDismiss: () {
                              scaffoldController.hideSideSheet();
                            },
                            color: Theme.of(context)
                                .colorScheme
                                .scrim
                                .withOpacity(Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? 0.4
                                    : 0.2),
                          ),
                        );
                      }
                    },
                  ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: _sideSheet(),
            ),
          ],
        );
      } else {
        Scaffold scaffold = widget.child(scaffoldController);
        return Scaffold(
          appBar: scaffold.appBar,
          backgroundColor: scaffold.backgroundColor,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: scaffold.body ?? const SizedBox(),
              ),
              _sideSheet(),
            ],
          ),
          bottomNavigationBar: scaffold.bottomNavigationBar,
          bottomSheet: scaffold.bottomSheet,
          drawer: scaffold.drawer,
          drawerDragStartBehavior: scaffold.drawerDragStartBehavior,
          drawerEdgeDragWidth: scaffold.drawerEdgeDragWidth,
          drawerEnableOpenDragGesture: scaffold.drawerEnableOpenDragGesture,
          drawerScrimColor: scaffold.drawerScrimColor,
          endDrawer: scaffold.endDrawer,
          endDrawerEnableOpenDragGesture:
              scaffold.endDrawerEnableOpenDragGesture,
          extendBody: scaffold.extendBody,
          extendBodyBehindAppBar: scaffold.extendBodyBehindAppBar,
          floatingActionButton: scaffold.floatingActionButton,
          floatingActionButtonAnimator: scaffold.floatingActionButtonAnimator,
          floatingActionButtonLocation: scaffold.floatingActionButtonLocation,
          key: scaffold.key,
          onDrawerChanged: scaffold.onDrawerChanged,
          onEndDrawerChanged: scaffold.onEndDrawerChanged,
          persistentFooterAlignment: scaffold.persistentFooterAlignment,
          persistentFooterButtons: scaffold.persistentFooterButtons,
          primary: scaffold.primary,
          resizeToAvoidBottomInset: scaffold.resizeToAvoidBottomInset,
          restorationId: scaffold.restorationId,
        );
      }
    } else {
      return widget.child(scaffoldController);
    }
  }
}
