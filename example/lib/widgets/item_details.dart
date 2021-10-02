import 'package:flutter/widgets.dart';

import '../models/dummy_item.dart';

class ItemDetails extends StatelessWidget {
  ItemDetails({required this.item, Key? key}) : super(key: key);

  final DummyItem item;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(item.description),
    );
  }
}
