import 'package:flutter/widgets.dart';

typedef MasterDetailPageRouteBuilder<T> = PageRoute<T> Function(
    WidgetBuilder? builder, RouteSettings settings);

/// Callback when the route in the details pane changes
typedef DetailsPaneRouteChangedCallback = void Function(
    String? route, Map<String, String>? parameters);

class LayoutHelper {
  /// Used to evaluate if both the master and detail panes should be shown
  static bool showBothPanes(
      BuildContext context, double twoPanesWidthBreakpoint) {
    return MediaQuery.of(context).size.width >= twoPanesWidthBreakpoint;
  }
}

class MasterDetailRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  factory MasterDetailRouteObserver(
      {required String initialRoute,
      required String detailsRoute,
      required DetailsPaneRouteChangedCallback onDetailsPaneRouteChanged}) {
    _initialRoute = initialRoute;
    _detailsRoute = detailsRoute;
    _onDetailsPaneRouteChanged = onDetailsPaneRouteChanged;
    return _instance;
  }

  MasterDetailRouteObserver._private();

  static final MasterDetailRouteObserver _instance =
      MasterDetailRouteObserver._private();

  static String? _initialRoute;

  static String? _detailsRoute;

  static late DetailsPaneRouteChangedCallback _onDetailsPaneRouteChanged;

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute!.settings.name!.toLowerCase() ==
        _initialRoute!.toLowerCase()) {
      _onDetailsPaneRouteChanged(_initialRoute, null);
      return;
    }
    _triggerDetailsChangedCallback(previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _triggerDetailsChangedCallback(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _triggerDetailsChangedCallback(newRoute);
  }

  void _triggerDetailsChangedCallback(Route? route) {
    if (route == null) {
      return;
    }

    final Uri uri = Uri.parse(route.settings.name!);
    if (uri.path.toLowerCase() == _detailsRoute!.toLowerCase()) {
      _onDetailsPaneRouteChanged(_detailsRoute, uri.queryParameters);
    }
  }
}
