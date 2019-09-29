import 'package:flutter/widgets.dart';

/// Contains helper methods to assist with building a master-detail layout
class LayoutHelper {
  /// Used to evaluate if both the master and detail panes should be shown
  static bool showBothPanes(
      BuildContext context, double twoPanesWidthBreakpoint) {
    return MediaQuery.of(context).size.width >= twoPanesWidthBreakpoint;
  }
}
