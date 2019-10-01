import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'layout_helper.dart';
import 'material_master_detail_page_route.dart';
import 'master_detail_route_observer.dart';

typedef MasterDetailPageRouteBuilder<T> = PageRoute<T> Function(
    WidgetBuilder builder, RouteSettings settings);

typedef DetailsChangedCallback = void Function(Object details);

/// A scaffold for implementing the master-detail flow
class MasterDetailScaffold extends StatefulWidget {
  const MasterDetailScaffold(
      {@required this.masterPaneBuilder,
      @required this.masterPaneWidth,
      @required this.detailsAppBar,
      @required this.detailsPaneBuilder,
      @required this.initialAppBar,
      @required this.initialRoute,
      @required this.detailsRoute,
      @required this.onDetailsChanged,
      this.initialDetailsPaneBuilder,
      this.twoPanesWidthBreakpoint = 600,
      this.pageRouteBuilder,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.floatingActionButtonAnimator,
      this.persistentFooterButtons,
      this.drawer,
      this.endDrawer,
      this.bottomNavigationBar,
      this.bottomSheet,
      this.backgroundColor,
      this.resizeToAvoidBottomInset,
      this.primary = true,
      this.drawerDragStartBehavior = DragStartBehavior.start,
      this.extendBody = false,
      this.extendBodyBehindAppBar = false,
      this.drawerScrimColor,
      this.drawerEdgeDragWidth,
      Key key})
      : assert(masterPaneBuilder != null),
        assert(masterPaneWidth != null),
        assert(detailsAppBar != null),
        assert(detailsPaneBuilder != null),
        assert(twoPanesWidthBreakpoint != null && twoPanesWidthBreakpoint > 0),
        assert(onDetailsChanged != null),
        super(key: key);

  /// The app bar to show when the both the master and details pane are visible.
  /// If only one pane is visible, this the app bar that is shown when it's the master pane that is visible i.e. when on the [initialRoute] as the user has selected an item yet
  final PreferredSizeWidget initialAppBar;

  /// The app bar to shown when only the details pane is visible i.e. when on the [detailsRoute] after the user has selected an item.
  final PreferredSizeWidget detailsAppBar;

  /// The name of the initial route. When the instance of the [Navigator] associated with the [MasterDetails]
  final String initialRoute;

  /// The route to use to show the content in the details pane
  final String detailsRoute;

  /// Creates the content to show in the master pane
  final WidgetBuilder masterPaneBuilder;

  /// Creates the content to show in the details pane
  final WidgetBuilder detailsPaneBuilder;

  /// The width of the master pane. The details pane will occur the remaining space
  final double masterPaneWidth;

  /// The minimum width at which both the master and details pane will be shown
  final double twoPanesWidthBreakpoint;

  /// Creates the widget to show when both the master and details pane are visible but there aren't any details to show.
  /// If null, then defaults to showing a [Container].
  final WidgetBuilder initialDetailsPaneBuilder;

  /// The button to display above the details pane and will only be shown when the [detailsPaneBuilder] is visible
  final Widget floatingActionButton;

  final FloatingActionButtonLocation floatingActionButtonLocation;

  final FloatingActionButtonAnimator floatingActionButtonAnimator;

  final bool extendBody;

  final bool extendBodyBehindAppBar;

  final List<Widget> persistentFooterButtons;

  final Widget drawer;

  final Widget endDrawer;

  final Color drawerScrimColor;

  final Color backgroundColor;

  final Widget bottomNavigationBar;

  final Widget bottomSheet;

  final bool resizeToAvoidBottomInset;

  final bool primary;

  final DragStartBehavior drawerDragStartBehavior;

  final double drawerEdgeDragWidth;

  /// Callback that is involved when the details that need to be displayed change.
  /// The callback is triggered in the following conditions:
  ///
  /// - when the [initialRoute] is displayed. The object passed through the callback would be null
  /// - When the [detailsRoute] is displayed. The object passed through the callback would be arguments passed to the route
  ///
  /// The details object passed through the callback can then be used to update the state of the application e.g. call `setState`
  final DetailsChangedCallback onDetailsChanged;

  /// Function that creates a modal route that can be used determine what the transition should be when navigation occurs.
  /// If left as null, then the [MaterialMasterDetailPageRoute] is used as a default
  final MasterDetailPageRouteBuilder pageRouteBuilder;

  /// The state of the nearest instance of the [MasterDetailScaffold] widget.
  static MasterDetailScaffoldState of(BuildContext context,
      {bool nullOk = false}) {
    assert(nullOk != null);
    assert(context != null);
    final MasterDetailScaffoldState result = context
        .ancestorStateOfType(const TypeMatcher<MasterDetailScaffoldState>());
    if (nullOk || result != null) return result;
    throw FlutterError(
        'MasterDetailScaffold.of() called with a context that does not contain a MasterDetailScaffold.');
  }

  @override
  MasterDetailScaffoldState createState() => MasterDetailScaffoldState();
}

class MasterDetailScaffoldState extends State<MasterDetailScaffold> {
  /// Whether both the master and detail panes are both being displayed
  bool get isDisplayingBothPanes =>
      LayoutHelper.showBothPanes(context, widget.twoPanesWidthBreakpoint);

  /// The navigator widget that encloses the details pane.
  /// Use this change the route that determines that details of the item that needs to be shown
  NavigatorState get detailsPaneNavigator => _navigatorKey.currentState;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final Navigator masterDetailNavigator = Navigator(
      key: _navigatorKey,
      initialRoute: widget.initialRoute,
      observers: [
        MasterDetailRouteObserver(
            initialRoute: widget.initialRoute,
            detailsRoute: widget.detailsRoute,
            onDetailsChanged: widget.onDetailsChanged)
      ],
      onGenerateRoute: (settings) {
        WidgetBuilder builder;
        if (settings.name == widget.initialRoute) {
          builder = (BuildContext context) => !LayoutHelper.showBothPanes(
                  context, widget.twoPanesWidthBreakpoint)
              ? Scaffold(
                  appBar: widget.initialAppBar,
                  body: Builder(builder: widget.masterPaneBuilder),
                  persistentFooterButtons: widget.persistentFooterButtons,
                  drawer: widget.drawer,
                  endDrawer: widget.endDrawer,
                  bottomNavigationBar: widget.bottomNavigationBar,
                  bottomSheet: widget.bottomSheet,
                  backgroundColor: widget.backgroundColor,
                  resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
                  primary: widget.primary,
                  drawerDragStartBehavior: widget.drawerDragStartBehavior,
                  extendBody: widget.extendBody,
                  extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
                  drawerScrimColor: widget.drawerScrimColor,
                  drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
                )
              : widget.initialDetailsPaneBuilder == null
                  ? Container()
                  : Builder(builder: widget.initialDetailsPaneBuilder);
        } else if (settings.name == widget.detailsRoute) {
          final Builder detailsPane =
              Builder(builder: widget.detailsPaneBuilder);
          builder = (BuildContext context) => !LayoutHelper.showBothPanes(
                  context, widget.twoPanesWidthBreakpoint)
              ? Scaffold(
                  appBar: widget.detailsAppBar,
                  body: detailsPane,
                  floatingActionButton: widget.floatingActionButton,
                  floatingActionButtonAnimator:
                      widget.floatingActionButtonAnimator,
                  floatingActionButtonLocation:
                      widget.floatingActionButtonLocation,
                )
              : detailsPane;
        }
        if (widget.pageRouteBuilder == null) {
          return MaterialMasterDetailPageRoute(
            builder: builder,
            settings: settings,
          );
        }
        final pageRoute = widget.pageRouteBuilder(builder, settings);
        return pageRoute;
      },
    );
    final Widget content = LayoutHelper.showBothPanes(
            context, widget.twoPanesWidthBreakpoint)
        ? Scaffold(
            appBar: widget.initialAppBar,
            body: Row(
              children: [
                Container(
                  child: Builder(
                    builder: widget.masterPaneBuilder,
                  ),
                  width: widget.masterPaneWidth,
                ),
                Expanded(
                  child: masterDetailNavigator,
                ),
              ],
            ),
            floatingActionButton: widget.floatingActionButton,
            floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
            floatingActionButtonLocation: widget.floatingActionButtonLocation,
            persistentFooterButtons: widget.persistentFooterButtons,
            drawer: widget.drawer,
            endDrawer: widget.endDrawer,
            bottomNavigationBar: widget.bottomNavigationBar,
            bottomSheet: widget.bottomSheet,
            backgroundColor: widget.backgroundColor,
            resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
            primary: widget.primary,
            drawerDragStartBehavior: widget.drawerDragStartBehavior,
            extendBody: widget.extendBody,
            extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
            drawerScrimColor: widget.drawerScrimColor,
            drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
          )
        : masterDetailNavigator;

    return WillPopScope(
      child: content,
      onWillPop: () async {
        // currently needed for better handling of the back navigation on the web as it's otherwise not possible
        if (await _navigatorKey.currentState.maybePop()) {
          return false;
        }
        return true;
      },
    );
  }
}
