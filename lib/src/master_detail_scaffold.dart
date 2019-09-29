import 'package:flutter/material.dart';

import 'layout_helper.dart';
import 'master_detail_navigator.dart';

/// A scaffold for implementing the master-detail flow
class MasterDetailScaffold extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final MasterDetailNavigator masterDetailNavigator = MasterDetailNavigator(
      navigatorKey: navigatorKey,
      initialRoute: initialRoute,
      detailsRoute: detailsRoute,
      detailsAppBar: detailsAppBar,
      detailsPaneContent: detailsPaneBuilder,
      masterPaneContent: masterPaneBuilder,
      masterAppBar: masterAppBar,
      initialDetailsPaneContent: initialDetailsPaneContent,
      twoPanesWidthBreakpoint: twoPanesWidthBreakpoint,
      floatingActionButton: floatingActionButton,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
    if (LayoutHelper.showBothPanes(context, twoPanesWidthBreakpoint)) {
      return Scaffold(
        appBar: masterAppBar,
        body: Row(
          children: [
            Container(
              child: Builder(
                builder: masterPaneBuilder,
              ),
              width: masterPaneWidth,
            ),
            Expanded(
              child: masterDetailNavigator,
            ),
          ],
        ),
        floatingActionButton: floatingActionButton,
        floatingActionButtonAnimator: floatingActionButtonAnimator,
        floatingActionButtonLocation: floatingActionButtonLocation,
      );
    }
    return masterDetailNavigator;
  }
}
