import 'package:flutter/material.dart';

import 'layout_helper.dart';
import 'master_detail_navigator.dart';

typedef MasterDetailPageRouteBuilder<T> = PageRoute<T> Function(
    WidgetBuilder, RouteSettings);

/// A scaffold for implementing the master-detail flow
class MasterDetailScaffold extends StatefulWidget {
  MasterDetailScaffold(
      {@required this.navigatorKey,
      @required this.masterPaneBuilder,
      @required this.masterPaneWidth,
      @required this.detailsAppBar,
      @required this.detailsPaneBuilder,
      @required this.masterAppBar,
      @required this.initialRoute,
      @required this.detailsRoute,
      this.initialDetailsPaneContent,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.floatingActionButtonAnimator,
      this.twoPanesWidthBreakpoint = 600,
      this.pageRouteBuilder,
      Key key})
      : assert(navigatorKey != null),
        assert(masterPaneBuilder != null),
        assert(masterPaneWidth != null),
        assert(detailsAppBar != null),
        assert(detailsPaneBuilder != null),
        assert(twoPanesWidthBreakpoint != null && twoPanesWidthBreakpoint > 0),
        super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;

  final PreferredSizeWidget masterAppBar;

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

  /// The widget to show when both the master and details pane are visible but there aren't any details to show.
  /// If null, then defaults to showing a [Container].
  final WidgetBuilder initialDetailsPaneContent;

  /// The button to display above the details pane and will only be shown when the [detailsPaneBuilder] is visible
  final Widget floatingActionButton;

  final FloatingActionButtonLocation floatingActionButtonLocation;

  final FloatingActionButtonAnimator floatingActionButtonAnimator;

  /// Function that creates a modal route that can be used determine what the transition should be when navigation occurs.
  /// If left as null, then the [MaterialMasterDetailPageRoute] is used as a default
  final MasterDetailPageRouteBuilder pageRouteBuilder;

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
  bool get isDisplayingBothPanes =>
      LayoutHelper.showBothPanes(context, widget.twoPanesWidthBreakpoint);

  @override
  Widget build(BuildContext context) {
    final MasterDetailNavigator masterDetailNavigator = MasterDetailNavigator(
      navigatorKey: widget.navigatorKey,
      initialRoute: widget.initialRoute,
      detailsRoute: widget.detailsRoute,
      detailsAppBar: widget.detailsAppBar,
      detailsPaneContent: widget.detailsPaneBuilder,
      masterPaneContent: widget.masterPaneBuilder,
      masterAppBar: widget.masterAppBar,
      initialDetailsPaneContent: widget.initialDetailsPaneContent,
      twoPanesWidthBreakpoint: widget.twoPanesWidthBreakpoint,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      pageRouteBuilder: widget.pageRouteBuilder,
    );
    final Widget content = LayoutHelper.showBothPanes(
            context, widget.twoPanesWidthBreakpoint)
        ? Scaffold(
            appBar: widget.masterAppBar,
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
          )
        : masterDetailNavigator;

    return WillPopScope(
      child: content,
      onWillPop: () async {
        // currently needed for better handling of the back navigation on the web as it's otherwise not possible
        if (widget.navigatorKey.currentState.canPop()) {
          widget.navigatorKey.currentState.pop();
          return false;
        }
        return true;
      },
    );
  }
}
