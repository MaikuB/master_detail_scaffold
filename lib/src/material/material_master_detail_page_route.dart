import 'package:flutter/material.dart';
import 'master_detail_scaffold.dart';

/// The default modal route with transition that is used by the [MasterDetailPageScaffold].
/// No animation transition occurs when both the master and detail panes are displayed.
/// When only pane is displayed then it functions the same as the [MaterialPageRoute].
class MaterialMasterDetailPageRoute<T> extends MaterialPageRoute<T> {
  MaterialMasterDetailPageRoute(
      {required WidgetBuilder builder, required RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (MasterDetailScaffold.of(context)!.isDisplayingBothPanes) {
      return child;
    }
    return super
        .buildTransitions(context, animation, secondaryAnimation, child);
  }
}
