import 'package:flutter/material.dart';

class GearCatalogModel {
  static List<String> itemNames = [
    'Nike Alphafly 3 Proto',
    'Garmin Forerunner 965',
    'Specialized Tarmac SL8',
    'Adidas Adizero Pro 4',
    'Strava Heart Rate Strap',
    'Hoka Cielo X1 Carbon',
    'Oakley Sutro Lite Prizm',
    'Wahoo Elemnt Bolt V2',
    'Asics Metaspeed Sky Paris',
    'Trek Madone SLR 9',
    'Shokz OpenRun Pro 2',
    'Coros Pace 3 GPS',
  ];

  GearItem getById(int id) => GearItem(id, itemNames[id % itemNames.length]);

  GearItem getByPosition(int position) {
    return getById(position);
  }
}

@immutable
class GearItem {
  final int id;
  final String name;
  final Color color;
  final int price = 42;

  GearItem(this.id, this.name)
      : color = Colors.primaries[id % Colors.primaries.length];

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is GearItem && other.id == id;
}