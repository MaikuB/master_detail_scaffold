import 'package:flutter/material.dart';

import 'layout_helper.dart';

/// The default modal route with transition that is used by the [MasterDetailPageScaffold].
/// No animation transition occurs when both the master and detail panes are displayed.
/// When only pane is displayed then it functions the same as the [MaterialPageRoute].
class MaterialMasterDetailPageRoute<T> extends MaterialPageRoute<T> {
  final double twoPanesWidthBreakpoint;
  MaterialMasterDetailPageRoute(
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
