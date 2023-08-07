import 'package:flutter/material.dart';

import 'controller.dart';
import 'data.dart';

enum WindowClass { compact, medium, expanded }

class SideSheetM3 extends StatelessWidget {
  final bool modal;
  final bool detached;
  final bool divider;
  final String headline;
  final Widget child;

  const SideSheetM3({
    super.key,
    this.modal = true,
    this.detached = false,
    this.divider = true,
    this.headline = "",
    this.child = const SizedBox(),
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

typedef DrawerBuilder = NavigationDrawer Function(
    ExtendScaffoldController scaffoldController);
typedef ScaffoldBuilder = Scaffold Function(
    ExtendScaffoldController scaffoldController);

class ExtendScaffold extends StatefulWidget {
  final DrawerBuilder? drawerLayout;
  final SideSheetM3? sideSheet;
  final ScaffoldBuilder child;

  const ExtendScaffold({
    super.key,
    this.drawerLayout,
    this.sideSheet,
    required this.child,
  });

  @override
  State<ExtendScaffold> createState() => _ExtendScaffoldState();

  static ExtendScaffoldController of(BuildContext context) {
    final sideSheetData =
        context.dependOnInheritedWidgetOfExactType<ExtendScaffoldData>();
    return sideSheetData!.controller;
  }
}

class _ExtendScaffoldState extends State<ExtendScaffold>
    with TickerProviderStateMixin {
  Duration modalEnterDuration = const Duration(milliseconds: 400);
  Duration modalExitDuration = const Duration(milliseconds: 200);
  Duration standardDuration = const Duration(milliseconds: 600);
  Curve easeIn = const Cubic(0.05, 0.7, 0.1, 1);
  Curve easeOut = const Cubic(0.3, 0, 0.8, 0.15);
  late AnimationController animation;
  bool visible = false;
  double x = 0;
  double y = 0;
  double m = 0;
  ExtendScaffoldController scaffoldController = ExtendScaffoldController();

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
    animation = AnimationController(
      vsync: this,
      duration: widget.sideSheet!.modal ? modalEnterDuration : standardDuration,
      reverseDuration:
          widget.sideSheet!.modal ? modalExitDuration : standardDuration,
    );
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
    if (widget.sideSheet != null) {
      animation = AnimationController(
        vsync: this,
        duration:
            widget.sideSheet!.modal ? modalEnterDuration : standardDuration,
        reverseDuration:
            widget.sideSheet!.modal ? modalExitDuration : standardDuration,
      );
    }
  }

  @override
  void dispose() {
    scaffoldController.dispose();
    animation.dispose();
    super.dispose();
  }

  Widget _sideSheet(WindowClass windowClass) {
    SideSheetM3 sideSheet = widget.sideSheet!;
    bool ltr = Directionality.of(context) == TextDirection.ltr;
    BorderRadius? borderRadius;
    EdgeInsets? margin;
    Border? verticalDivider;
    double elevation = 1;

    if (windowClass == WindowClass.compact && !sideSheet.modal ||
        windowClass != WindowClass.compact && sideSheet.modal) {
      if (sideSheet.detached) {
        margin = EdgeInsets.fromLTRB(ltr ? 64 : m, 16, ltr ? m : 64, 16);
        borderRadius = BorderRadius.circular(28);
      } else {
        margin = EdgeInsets.only(left: ltr ? 64 : 0, right: ltr ? 0 : 64);
        borderRadius = ltr
            ? const BorderRadius.horizontal(left: Radius.circular(28))
            : const BorderRadius.horizontal(right: Radius.circular(28));
      }
    } else {
      if (sideSheet.detached) {
        margin = ltr
            ? EdgeInsets.fromLTRB(0, 0, m, 16)
            : EdgeInsets.fromLTRB(m, 0, 0, 16);
        borderRadius = BorderRadius.circular(28);
      } else {
        elevation = 0;
        margin = EdgeInsets.zero;
        borderRadius = BorderRadius.zero;
        if (sideSheet.divider) {
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
    }

    return AnimatedContainer(
      duration: visible ? animation.duration! : animation.reverseDuration!,
      curve: visible ? easeIn : (sideSheet.modal ? easeOut : easeIn),
      margin: margin,
      constraints:
          BoxConstraints(maxWidth: x, minWidth: y, minHeight: double.maxFinite),
      clipBehavior: (sideSheet.modal ||
              sideSheet.detached ||
              windowClass == WindowClass.compact)
          ? Clip.antiAlias
          : Clip.none,
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
            reverseCurve: sideSheet.modal ? easeOut : easeIn,
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
                    title: Text(sideSheet.headline,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant)),
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

  Widget _layout(WindowClass windowClass) {
    Scaffold scaffold = widget.child(scaffoldController);
    if (widget.sideSheet != null) {
      if (!widget.sideSheet!.modal && windowClass == WindowClass.compact ||
          widget.sideSheet!.modal && windowClass != WindowClass.compact) {
        return Stack(
          children: [
            Scaffold(
              appBar: scaffold.appBar,
              backgroundColor: scaffold.backgroundColor,
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: scaffold.body ?? const SizedBox(),
                  ),
                ],
              ),
              bottomNavigationBar: scaffold.bottomNavigationBar,
              bottomSheet: scaffold.bottomSheet,
              drawer: (widget.drawerLayout != null)
                  ? NavigationDrawer(
                      selectedIndex: widget
                          .drawerLayout!(scaffoldController).selectedIndex,
                      onDestinationSelected: widget
                          .drawerLayout!(scaffoldController)
                          .onDestinationSelected,
                      children:
                          widget.drawerLayout!(scaffoldController).children)
                  : null,
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
              floatingActionButtonAnimator:
                  scaffold.floatingActionButtonAnimator,
              floatingActionButtonLocation:
                  scaffold.floatingActionButtonLocation,
              key: scaffold.key,
              onDrawerChanged: scaffold.onDrawerChanged,
              onEndDrawerChanged: scaffold.onEndDrawerChanged,
              persistentFooterAlignment: scaffold.persistentFooterAlignment,
              persistentFooterButtons: scaffold.persistentFooterButtons,
              primary: scaffold.primary,
              resizeToAvoidBottomInset: scaffold.resizeToAvoidBottomInset,
              restorationId: scaffold.restorationId,
            ),
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
              child: _sideSheet(windowClass),
            ),
          ],
        );
      } else {
        return Scaffold(
          appBar: (widget.drawerLayout != null &&
                  windowClass == WindowClass.expanded)
              ? null
              : scaffold.appBar,
          backgroundColor: scaffold.backgroundColor,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: (widget.drawerLayout != null &&
                    windowClass == WindowClass.expanded)
                ? [
                    NavigationDrawer(
                      elevation: 0,
                      selectedIndex: widget
                          .drawerLayout!(scaffoldController).selectedIndex,
                      onDestinationSelected: widget
                          .drawerLayout!(scaffoldController)
                          .onDestinationSelected,
                      children:
                          widget.drawerLayout!(scaffoldController).children,
                    ),
                    Expanded(
                      child: Scaffold(
                        appBar: scaffold.appBar,
                        backgroundColor: scaffold.backgroundColor,
                        body: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: scaffold.body ?? const SizedBox(),
                            ),
                            _sideSheet(windowClass),
                          ],
                        ),
                        bottomNavigationBar: scaffold.bottomNavigationBar,
                        bottomSheet: scaffold.bottomSheet,
                        drawer: (widget.drawerLayout != null &&
                                windowClass == WindowClass.medium)
                            ? NavigationDrawer(
                                selectedIndex: widget
                                    .drawerLayout!(scaffoldController)
                                    .selectedIndex,
                                onDestinationSelected: widget
                                    .drawerLayout!(scaffoldController)
                                    .onDestinationSelected,
                                children: widget
                                    .drawerLayout!(scaffoldController).children)
                            : null,
                        drawerDragStartBehavior:
                            scaffold.drawerDragStartBehavior,
                        drawerEdgeDragWidth: scaffold.drawerEdgeDragWidth,
                        drawerEnableOpenDragGesture:
                            scaffold.drawerEnableOpenDragGesture,
                        drawerScrimColor: scaffold.drawerScrimColor,
                        endDrawer: scaffold.endDrawer,
                        endDrawerEnableOpenDragGesture:
                            scaffold.endDrawerEnableOpenDragGesture,
                        extendBody: scaffold.extendBody,
                        extendBodyBehindAppBar: scaffold.extendBodyBehindAppBar,
                        floatingActionButton: scaffold.floatingActionButton,
                        floatingActionButtonAnimator:
                            scaffold.floatingActionButtonAnimator,
                        floatingActionButtonLocation:
                            scaffold.floatingActionButtonLocation,
                        key: scaffold.key,
                        onDrawerChanged: scaffold.onDrawerChanged,
                        onEndDrawerChanged: scaffold.onEndDrawerChanged,
                        persistentFooterAlignment:
                            scaffold.persistentFooterAlignment,
                        persistentFooterButtons:
                            scaffold.persistentFooterButtons,
                        primary: scaffold.primary,
                        resizeToAvoidBottomInset:
                            scaffold.resizeToAvoidBottomInset,
                        restorationId: scaffold.restorationId,
                      ),
                    ),
                  ]
                : [
                    Expanded(
                      child: scaffold.body ?? const SizedBox(),
                    ),
                    _sideSheet(windowClass),
                  ],
          ),
          bottomNavigationBar: scaffold.bottomNavigationBar,
          bottomSheet: scaffold.bottomSheet,
          drawer: (widget.drawerLayout != null &&
                  windowClass == WindowClass.medium)
              ? NavigationDrawer(
                  selectedIndex:
                      widget.drawerLayout!(scaffoldController).selectedIndex,
                  onDestinationSelected: widget
                      .drawerLayout!(scaffoldController).onDestinationSelected,
                  children: widget.drawerLayout!(scaffoldController).children)
              : null,
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 840) {
          return _layout(WindowClass.expanded);
        } else if (600 < constraints.maxWidth && constraints.maxWidth < 840) {
          return _layout(WindowClass.medium);
        } else {
          return _layout(WindowClass.compact);
        }
      },
    );
  }
}
