import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_detail_scaffold/master_detail_scaffold.dart';
import 'package:provider/provider.dart';
import 'constants/route_names.dart';
import 'models/dummy_item.dart';
import 'widgets/item_details.dart';
import 'widgets/items_list.dart';
import 'models/dummy_content.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DummyItem _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Provider<DummyContent>(
      create: (_) => DummyContent(),
      child: MaterialApp(
        title: 'Master-detail Flow Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<DummyContent>(
          builder: (_, content, __) {
            return MasterDetailScaffold(
              onDetailsPaneRouteChanged:
                  (String route, Map<String, String> parameters) {
                setState(() {
                  if (route == RouteNames.itemDetails) {
                    _selectedItem = content.items.firstWhere(
                        (item) => item.id == parameters['id'],
                        orElse: null);
                    return;
                  }
                  _selectedItem = null;
                });
              },
              twoPanesWidthBreakpoint: 600,
              initialRoute: RouteNames.home,
              detailsRoute: RouteNames.itemDetails,
              initialAppBar: AppBar(
                title: Text('Master-detail Flow Demo'),
              ),
              masterPaneWidth: 400,
              masterPaneBuilder: (BuildContext context) => ItemsList(
                selectedItem: _selectedItem,
              ),
              detailsPaneBuilder: (BuildContext context) =>
                  ItemDetails(item: _selectedItem),
              detailsAppBar: AppBar(
                // the [Builder] widget is needed to ensure that the widget for displaying the title gets rebuilt based on the selected item.
                // Without the [Builder] widget, the title is set to the value that was originally passed through
                title: Builder(
                  builder: (context) => Text(_selectedItem.title),
                ),
              ),
              floatingActionButton: Visibility(
                visible: _selectedItem != null,
                child: Builder(
                  builder: (context) => FloatingActionButton(
                    child: Icon(Icons.reply),
                    onPressed: () {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Replying to ${_selectedItem.title}'),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
