import 'package:flutter/foundation.dart';

class ListPage<ItemType> {
  ListPage({
    @required this.grandTotalCount,
    @required this.itemList,
  })  : assert(grandTotalCount != null),
        assert(itemList != null);

  int grandTotalCount;
  List<ItemType> itemList;

  bool isLastPage(int previouslyFetchedItemsCount) {
    final newItemsCount = itemList.length;
    final totalFetchedItemsCount = previouslyFetchedItemsCount + newItemsCount;
    return totalFetchedItemsCount == grandTotalCount;
  }
}
