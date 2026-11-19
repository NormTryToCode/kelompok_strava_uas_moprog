import 'package:flutter/foundation.dart';
import 'gear_catalog.dart';

class GearBagModel extends ChangeNotifier {
  late GearCatalogModel _catalog;

  final List<int> _itemIds = [];

  GearCatalogModel get catalog => _catalog;

  set catalog(GearCatalogModel newCatalog) {
    _catalog = newCatalog;
    notifyListeners();
  }

  List<GearItem> get items =>
      _itemIds.map((id) => _catalog.getById(id)).toList();

  int get totalPrice =>
      items.fold(0, (total, current) => total + current.price);

  void add(GearItem item) {
    _itemIds.add(item.id);
    notifyListeners();
  }

  void remove(GearItem item) {
    _itemIds.remove(item.id);
    notifyListeners();
  }
}