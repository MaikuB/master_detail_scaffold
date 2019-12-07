import 'package:flutter/widgets.dart';

typedef MasterDetailPageRouteBuilder<T> = PageRoute<T> Function(
    WidgetBuilder builder, RouteSettings settings);

typedef DetailsChangedCallback = void Function(dynamic details);

class LayoutHelper {
  /// Used to evaluate if both the master and detail panes should be shown
  static bool showBothPanes(
      BuildContext context, double twoPanesWidthBreakpoint) {
    return MediaQuery.of(context).size.width >= twoPanesWidthBreakpoint;
  }
}

class MasterDetailRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  // TODO: allow details route to a pattern e.g. itemId={itemId}
  factory MasterDetailRouteObserver(
      {@required String initialRoute,
      @required String detailsRoute,
      @required DetailsChangedCallback onDetailsChanged}) {
    _initialRoute = initialRoute;
    _detailsRoute = detailsRoute;
    _onDetailsChanged = onDetailsChanged;
    return _instance;
  }

  MasterDetailRouteObserver._private();

  static final MasterDetailRouteObserver _instance =
      MasterDetailRouteObserver._private();

  static String _initialRoute;

  static String _detailsRoute;

  static DetailsChangedCallback _onDetailsChanged;

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute.settings.name == _initialRoute) {
      _onDetailsChanged(null);
      return;
    }
    _triggerDetailsChangedCallback(previousRoute);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    _triggerDetailsChangedCallback(route);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _triggerDetailsChangedCallback(newRoute);
  }

  void _triggerDetailsChangedCallback(Route route) {
    if (route == null) {
      return;
    }

    if (route.settings.name == _detailsRoute) {
      _onDetailsChanged(route.settings.arguments);
    }
  }
}
