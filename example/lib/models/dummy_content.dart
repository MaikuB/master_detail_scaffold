import 'package:flutter/foundation.dart';

import 'dummy_item.dart';

class DummyContent extends ChangeNotifier {
  DummyContent() {
    for (int i = 0; i < 10; i++) {
      final int itemNumber = i + 1;
      items.add(
          DummyItem('Item $itemNumber', 'Description for item $itemNumber'));
    }
  }

  final List<DummyItem> items = [];

  DummyItem selectedItem;

  void updateSelectedItem(DummyItem item) {
    selectedItem = item;
    notifyListeners();
  }
}
