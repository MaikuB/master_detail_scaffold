import 'package:flutter/material.dart';

import 'layout_helper.dart';

class MasterDetailPageRoute<T> extends MaterialPageRoute<T> {
  final double twoPanesWidthBreakpoint;
  MasterDetailPageRoute(
      {@required WidgetBuilder builder,
      @required RouteSettings settings,
      @required this.twoPanesWidthBreakpoint})
      : assert(twoPanesWidthBreakpoint != null && twoPanesWidthBreakpoint > 0),
        super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (LayoutHelper.showBothPanes(context, twoPanesWidthBreakpoint)) {
      return child;
    }
    return super
        .buildTransitions(context, animation, secondaryAnimation, child);
  }
}
