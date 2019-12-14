import 'dummy_item.dart';

class DummyContent {
  DummyContent() {
    for (int i = 0; i < 10; i++) {
      final int itemNumber = i + 1;
      items.add(DummyItem(
          id: itemNumber.toString(),
          title: 'Item $itemNumber',
          description: 'Description for item $itemNumber'));
    }
  }

  final List<DummyItem> items = [];
}
