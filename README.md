# master_detail_scaffold

[![pub package](https://img.shields.io/pub/v/master_detail_scaffold.svg)](https://pub.dartlang.org/packages/master_detail_scaffold)
[![Build Status](https://api.cirrus-ci.com/github/MaikuB/master_detail_scaffold.svg)](https://cirrus-ci.com/github/MaikuB/master_detail_scaffold/master)

A Flutter package that contains widgets that help implement a responsive master-detail layout. The widget is based on the material design scaffold and was based on exploring responsive layouts as covered in [this article](https://dexterx.dev/creating-a-responsive-flutter-application-with-a-navigation-drawer/). As such, it may not suitable for all scenarios (e.g. nested/multiple master-detail layouts) as it has been shared in case there are other members of the community who may find it useful. Go [here](https://maikub.github.io/masterdetailscaffold/) to see the example running on the web.

**NOTE**: this uses the imperative `Navigator`  (1.0) APIs. There are currently no plans to migrate this to `Navigator` 2.0 so those that need `Navigator` 2.0 should look at forking this project

## Getting started

The package exposes a `MasterDetailScaffold` widget that is built based on Flutter's [`Scaffold`](https://api.flutter.dev/flutter/material/Scaffold-class.html) widget. Therefore, you can expect the majority of the properties you're familiar to exist and can be use it in a similar way you would normally do with a `Scaffold` widget. Create a class and use the `MasterDetailScaffold` widget within your build method

```dart
MasterDetailScaffold(
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
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Replying to ${_selectedItem.title}'),
            ),
            );
        },
        ),
    ),
    ),
);
```

The key parts are

* `twoPanesWidthBreakpoint`: the width breakpoint for showing both the master and details pane together. The back button is hidden whe both panes are visible
* `initialRoute`: the name of the route use when no details are shown in the details pane
* `detailsRoute`: the name of the route to use when details are shown in the details pane
* `masterPaneWidth`: the width of the master pane. Applicable when both the master and details pane are shown
* `masterPaneBuilder`: determines what to show in the master pane. This is typically a list of items and is left to developers to implement what they should render here
* `detailsPaneBuilder`: determines what to show in the details pane. When both the master and details pane are shown, it is assumed to take the remaining of width of the screen
* `onDetailsPaneRouteChanged`: the callback trigger when the route in the details pane changes. Use this to find out get the route/path and query string parameters so you can display the appropriate content

To trigger navigation in the details pane, you can retrieve the navigator associated with the details pane by calling `MasterDetailScaffold.of(context).detailsPaneNavigator`. Normally, this wouldn't be needed and you would only need to call `Navigator.of(context)` but this doesn't appear to get the navigator associated with the details pane. URI-based navigation is expected via named routes. By default the page transition applied is the same as the `MaterialPageRoute`, though when both panes are shown no animation is used when the details change. Should you want to use a different transition style, this can be specified using the `pageRouteBuilder` property.

Note that I've found that entering a URL that should go to a specific details page doesn't work. This is likely due to the fact that Flutter's web support for web development isn't stable yet. Should you find a solution for this, please submit a pull request.

Should you want to see this running, a complete example can be found in the GitHub repository.


