import 'package:flutter/material.dart';
import 'package:master_detail_scaffold/master_detail_scaffold.dart';
import 'package:master_detail_scaffold_example/constants/route_names.dart';
import 'package:master_detail_scaffold_example/widgets/item_details.dart';
import 'package:master_detail_scaffold_example/widgets/items_list.dart';
import 'package:provider/provider.dart';

import 'models/dummy_content.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DummyContent>(
      builder: (_) => DummyContent(),
      child: MaterialApp(
        title: 'Master-detail Flow Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<DummyContent>(
          builder: (_, content, __) => MasterDetailScaffold(
            navigatorKey: _navigatorKey,
            initialRoute: RouteNames.home,
            detailsRoute: RouteNames.itemDetails,
            masterAppBar: AppBar(
              title: Text('Master-detail Flow Demo'),
            ),
            masterPaneWidth: 400,
            masterPaneBuilder: (BuildContext context) => ItemsList(
              navigatorKey: _navigatorKey,
            ),
            detailsPaneBuilder: (BuildContext context) =>
                ItemDetails(item: content.selectedItem),
            detailsAppBar: AppBar(
              // the [Builder] widget is needed to ensure that the widget for displaying the title gets rebuilt based on the selected item.
              // Without the [Builder] widget, the title is set to the value that was originally passed through
              title: Builder(
                builder: (context) => Text(content.selectedItem?.title ?? ''),
              ),
            ),
            floatingActionButton: Builder(
              builder: (context) => FloatingActionButton(
                child: Icon(Icons.reply),
                onPressed: () {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Replying to ${content.selectedItem.title}'),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
