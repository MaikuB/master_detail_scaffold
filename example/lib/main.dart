import 'package:flutter/material.dart';
import 'package:master_detail_scaffold/master_detail_scaffold.dart';
import 'package:master_detail_scaffold_example/constants/route_names.dart';
import 'package:master_detail_scaffold_example/models/dummy_item.dart';
import 'package:master_detail_scaffold_example/widgets/item_details.dart';
import 'package:master_detail_scaffold_example/widgets/items_list.dart';
import 'package:provider/provider.dart';

import 'models/dummy_content.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  DummyItem selectedItem;

  @override
  Widget build(BuildContext context) {
    return Provider<DummyContent>(
      builder: (_) => DummyContent(),
      child: MaterialApp(
        title: 'Master-detail Flow Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<DummyContent>(
          builder: (_, content, __) => MasterDetailScaffold(
            onDetailsChanged: (details) {
              setState(() {
                selectedItem = details as DummyItem;
              });
            },
            navigatorKey: _navigatorKey,
            initialRoute: RouteNames.home,
            detailsRoute: RouteNames.itemDetails,
            masterAppBar: AppBar(
              title: Text('Master-detail Flow Demo'),
            ),
            masterPaneWidth: 400,
            masterPaneBuilder: (BuildContext context) => ItemsList(
              selectedItem: selectedItem,
              navigatorKey: _navigatorKey,
            ),
            detailsPaneBuilder: (BuildContext context) =>
                ItemDetails(item: selectedItem),
            detailsAppBar: AppBar(
              // the [Builder] widget is needed to ensure that the widget for displaying the title gets rebuilt based on the selected item.
              // Without the [Builder] widget, the title is set to the value that was originally passed through
              title: Builder(
                builder: (context) => Text(selectedItem.title),
              ),
            ),
            floatingActionButton: Builder(
              builder: (context) => FloatingActionButton(
                child: Icon(Icons.reply),
                onPressed: () {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Replying to ${selectedItem.title}'),
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
