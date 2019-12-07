import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_detail_scaffold/master_detail_scaffold.dart';
import 'package:provider/provider.dart';

import '../constants/route_names.dart';
import '../models/dummy_content.dart';
import '../models/dummy_item.dart';

class ItemsList extends StatelessWidget {
  const ItemsList({@required this.selectedItem, Key key}) : super(key: key);

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
              await MasterDetailScaffold.of(context)
                  .detailsPaneNavigator
                  .pushNamed(RouteNames.itemDetails, arguments: item);
            },
          );
        },
      ),
    );
  }
}
