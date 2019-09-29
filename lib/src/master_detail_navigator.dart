import 'package:flutter/material.dart';
import 'package:master_detail_scaffold/master_detail_scaffold.dart';

import 'layout_helper.dart';
import 'material_master_detail_page_route.dart';

class MasterDetailNavigator extends StatelessWidget {
  const MasterDetailNavigator(
      {@required this.masterAppBar,
      @required this.detailsAppBar,
      @required this.detailsRoute,
      @required this.initialRoute,
      @required this.twoPanesWidthBreakpoint,
      @required this.navigatorKey,
      @required this.detailsPaneContent,
      @required this.masterPaneContent,
      this.initialDetailsPaneContent,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.floatingActionButtonAnimator,
      this.pageRouteBuilder,
      Key key})
      : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;

  final String initialRoute;

  final String detailsRoute;

  final PreferredSizeWidget masterAppBar;

  final PreferredSizeWidget detailsAppBar;

  final double twoPanesWidthBreakpoint;

  final WidgetBuilder masterPaneContent;

  final WidgetBuilder detailsPaneContent;

  final WidgetBuilder initialDetailsPaneContent;

  final Widget floatingActionButton;

  final FloatingActionButtonLocation floatingActionButtonLocation;

  final FloatingActionButtonAnimator floatingActionButtonAnimator;

  final MasterDetailPageRouteBuilder pageRouteBuilder;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        WidgetBuilder builder;
        if (settings.name == initialRoute) {
          builder = (BuildContext context) =>
              !LayoutHelper.showBothPanes(context, twoPanesWidthBreakpoint)
                  ? Scaffold(
                      appBar: masterAppBar,
                      body: Builder(builder: masterPaneContent),
                    )
                  : initialDetailsPaneContent == null
                      ? Container()
                      : Builder(builder: initialDetailsPaneContent);
        } else if (settings.name == detailsRoute) {
          final Builder detailsPaneBuilder =
              Builder(builder: detailsPaneContent);
          builder = (BuildContext context) => !LayoutHelper.showBothPanes(
                  context, twoPanesWidthBreakpoint)
              ? Scaffold(
                  appBar: detailsAppBar,
                  body: detailsPaneBuilder,
                  floatingActionButton: floatingActionButton,
                  floatingActionButtonAnimator: floatingActionButtonAnimator,
                  floatingActionButtonLocation: floatingActionButtonLocation,
                )
              : detailsPaneBuilder;
        }
        if (pageRouteBuilder == null) {
          return MaterialMasterDetailPageRoute(
              builder: builder,
              settings: settings,
              twoPanesWidthBreakpoint: twoPanesWidthBreakpoint);
        }
        final pageRoute = pageRouteBuilder(builder, settings);
        return pageRoute;
      },
    );
  }
}
