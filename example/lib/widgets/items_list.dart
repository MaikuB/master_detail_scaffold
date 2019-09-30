import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/route_names.dart';
import '../models/dummy_content.dart';
import '../models/dummy_item.dart';

class ItemsList extends StatelessWidget {
  const ItemsList(
      {@required this.selectedItem, @required this.navigatorKey, Key key})
      : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;

  final DummyItem selectedItem;

  @override
  Widget build(BuildContext context) {
    return Consumer<DummyContent>(
      builder: (_, content, __) => ListView.builder(
        itemCount: content.items.length,
        itemBuilder: (context, index) {
          final DummyItem item = content.items[index];
          return ListTile(
            title: Text(item.title),
            selected: item == selectedItem,
            onTap: () async {
              await navigatorKey.currentState
                  .pushNamed(RouteNames.itemDetails, arguments: item);
            },
          );
        },
      ),
    );
  }
}
