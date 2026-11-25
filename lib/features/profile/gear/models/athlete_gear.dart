import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/int_extensions.dart';

enum GearCategory {
  bike,
  shoes,
  wearable,
  swim,
}

extension GearCategoryExtension on GearCategory {
  String get label {
    switch (this) {
      case GearCategory.bike:
        return 'Bike';
      case GearCategory.shoes:
        return 'Footwear';
      case GearCategory.wearable:
        return 'GPS & Sensor';
      case GearCategory.swim:
        return 'Swim Kit';
    }
  }

  String get pluralLabel {
    switch (this) {
      case GearCategory.bike:
        return 'Bikes';
      case GearCategory.shoes:
        return 'Footwear';
      case GearCategory.wearable:
        return 'GPS & Sensors';
      case GearCategory.swim:
        return 'Swim Kit';
    }
  }

  String get sectionHeader {
    switch (this) {
      case GearCategory.bike:
        return 'BIKES';
      case GearCategory.shoes:
        return 'FOOTWEAR';
      case GearCategory.wearable:
        return 'GPS & SENSORS';
      case GearCategory.swim:
        return 'SWIM KIT';
    }
  }

  String get retiredLabel {
    switch (this) {
      case GearCategory.bike:
        return 'Retired Bikes';
      case GearCategory.shoes:
        return 'Retired Footwear';
      case GearCategory.wearable:
        return 'Retired Devices';
      case GearCategory.swim:
        return 'Retired Swim Kit';
    }
  }

  String get subTypeFieldLabel {
    switch (this) {
      case GearCategory.bike:
        return 'Bike Discipline';
      case GearCategory.shoes:
        return 'Footwear Category';
      case GearCategory.wearable:
        return 'Device Type';
      case GearCategory.swim:
        return 'Swim Gear Type';
    }
  }

  String get sportFilterGroupTitle {
    switch (this) {
      case GearCategory.bike:
        return 'Cycling Disciplines';
      case GearCategory.shoes:
        return 'Running & Trail';
      case GearCategory.wearable:
        return 'Multi-Sport Telemetry';
      case GearCategory.swim:
        return 'Aquatics & Open Water';
    }
  }

  IconData get icon {
    switch (this) {
      case GearCategory.bike:
        return Icons.pedal_bike_rounded;
      case GearCategory.shoes:
        return Icons.directions_run_rounded;
      case GearCategory.wearable:
        return Icons.watch_rounded;
      case GearCategory.swim:
        return Icons.pool_rounded;
    }
  }

  List<String> get defaultSportsOptions {
    switch (this) {
      case GearCategory.bike:
        return const [
          'Road Cycling',
          'Mountain Biking',
          'Gravel Riding',
          'Virtual Cycling',
          'E-Bike Ride',
          'E-MTB Trail',
          'Handcycling',
          'Velomobile',
        ];
      case GearCategory.shoes:
        return const [
          'Road Running',
          'Trail Running',
          'Virtual Run',
          'Brisk Walking',
          'Alpine Hiking',
        ];
      case GearCategory.wearable:
        return const [
          'Running',
          'Cycling',
          'Swimming',
          'Trail Running',
          'Hiking',
          'Triathlon',
          'Strength & Conditioning',
        ];
      case GearCategory.swim:
        return const [
          'Pool Swimming',
          'Open Water Swim',
          'Triathlon',
          'Aquathlon',
        ];
    }
  }

  List<String> get subTypeOptions {
    switch (this) {
      case GearCategory.bike:
        return const [
          'Mountain Bike',
          'Cyclocross Bike',
          'Road Race Bike',
          'Time Trial / Aero',
          'Gravel Bike',
          'Electric Bike (E-Bike)',
          'Folding / Urban Bike',
        ];
      case GearCategory.shoes:
        return const [
          'Road Trainer',
          'Trail Runner',
          'Carbon Race Super-Shoe',
          'Daily Cushion Trainer',
          'Walking & Light Hike',
        ];
      case GearCategory.wearable:
        return const [
          'GPS Sports Watch',
          'Heart Rate Strap (HRM)',
          'GPS Bike Computer',
          'Power Meter',
          'Running Dynamics Pod',
        ];
      case GearCategory.swim:
        return const [
          'Hydrodynamic Goggles',
          'Open Water Wetsuit',
          'Training Fins',
          'Hand Paddles & Pull Buoy',
          'Swim Buoy / Watch',
        ];
    }
  }

  List<String> get presetBrands {
    switch (this) {
      case GearCategory.bike:
        return const [
          'Bianchi',
          'BMC',
          'Brompton',
          'Cannondale',
          'Canyon',
          'Cervélo',
          'Colnago',
          'Element',
          'Factor',
          'Focus',
          'Giant',
          'Kona',
          'Look',
          'Marin',
          'Merida',
          'Orbea',
          'Pacific',
          'Pinarello',
          'Polygon',
          'Ridley',
          'Santa Cruz',
          'Scott',
          'Specialized',
          'Thrill',
          'Trek',
          'United',
          'Wilier',
          'Wimcycle',
        ];
      case GearCategory.shoes:
        return const [
          '+8000',
          '361°',
          '4F',
          '4T2',
          '5.11',
          '910 Nineten',
          'Abeo',
          'Aborigen Sandals',
          'Abros',
          'Achilles',
          'Adidas',
          'Altra',
          'Asics',
          'Brooks',
          'Decathlon Kiprun',
          'Diadora',
          'Hoka',
          'La Sportiva',
          'League',
          'Merrell',
          'Mills',
          'Mizuno',
          'New Balance',
          'Nike',
          'On Running',
          'Ortuseight',
          'Puma',
          'Reebok',
          'Salomon',
          'Saucony',
          'Skechers',
          'Specs',
          'Under Armour',
        ];
      case GearCategory.wearable:
        return const [
          'Amazfit',
          'Apple',
          'Bryton',
          'Coros',
          'Favero Assioma',
          'Fitbit',
          'Garmin',
          'Hammerhead',
          'Huawei',
          'iGPSPORT',
          'Magene',
          'Polar',
          'Samsung',
          'Shokz',
          'Stages',
          'Suunto',
          'Wahoo',
          'Whoop',
          'Xiaomi',
        ];
      case GearCategory.swim:
        return const [
          '2XU',
          'Arena',
          'Decathlon Nabaiji',
          'Finis',
          'Funkita',
          'HUUB',
          'Mad Wave',
          'MP Michael Phelps',
          'Orca',
          'Speedo',
          'TYR',
          'Zoggs',
          'Zone3',
        ];
    }
  }

  List<int> get maxDistancePresets {
    switch (this) {
      case GearCategory.shoes:
        return const [400, 500, 600, 700, 800, 1000, 1200];
      case GearCategory.swim:
        return const [50, 100, 200, 300, 500];
      case GearCategory.bike:
      case GearCategory.wearable:
        return const [];
    }
  }
}

const Map<String, String> _legacyTermMap = {
  'sepeda gunung': 'Mountain Bike',
  'sepeda cross': 'Cyclocross Bike',
  'sepeda balap': 'Road Race Bike',
  'sepeda tt': 'Time Trial / Aero',
  'bersepeda medan kerikil': 'Gravel Bike',
  'sepeda e-bike': 'Electric Bike (E-Bike)',
  'sepeda lipat / kota': 'Folding / Urban Bike',
  'lari jalan raya (road)': 'Road Trainer',
  'lari trail': 'Trail Running',
  'sepatu lomba (carbon / racing)': 'Carbon Race Super-Shoe',
  'latihan harian (daily trainer)': 'Daily Cushion Trainer',
  'jalan santai & mendaki': 'Walking & Light Hike',
  'jam tangan gps': 'GPS Sports Watch',
  'sensor detak jantung (hrm)': 'Heart Rate Strap (HRM)',
  'kacamata renang (goggles)': 'Hydrodynamic Goggles',
  'sirip renang (fins)': 'Training Fins',
  'jam / pelampung renang': 'Swim Buoy / Watch',
  'bersepeda': 'Road Cycling',
  'bersepeda gunung': 'Mountain Biking',
  'medan kerikil': 'Gravel Riding',
  'bersepeda virtual': 'Virtual Cycling',
  'bersepeda e-bike': 'E-Bike Ride',
  'perjalanan sepeda elektrik gunung': 'E-MTB Trail',
  'handcycle': 'Handcycling',
  'berlari': 'Road Running',
  'lari virtual': 'Virtual Run',
  'berjalan': 'Brisk Walking',
  'mendaki': 'Alpine Hiking',
  'berenang': 'Pool Swimming',
  'renang perairan terbuka': 'Open Water Swim',
  'latihan kebugaran': 'Strength & Conditioning',
  'akuatlon': 'Aquathlon',
};

String translateLegacyGearTerm(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return '';
  return _legacyTermMap[trimmed.toLowerCase()] ?? trimmed;
}

@immutable
class AthleteGear {
  final String id;
  final GearCategory category;
  final String nickname;
  final String subType;
  final String brand;
  final String model;
  final List<String> defaultSports;
  final double? weightKg;
  final int? maxDistanceKm;
  final int? batteryHours;
  final double currentDistanceKm;
  final String notes;
  final bool isRetired;
  final DateTime createdAt;

  const AthleteGear({
    required this.id,
    required this.category,
    required this.nickname,
    required this.subType,
    required this.brand,
    required this.model,
    required this.defaultSports,
    this.weightKg,
    this.maxDistanceKm,
    this.batteryHours,
    this.currentDistanceKm = 0.0,
    this.notes = '',
    this.isRetired = false,
    required this.createdAt,
  });

  String get displayName {
    if (nickname.trim().isNotEmpty) {
      return nickname.trim();
    }
    final combined = '${brand.trim()} ${model.trim()}'.trim();
    return combined.isNotEmpty ? combined : category.label;
  }

  String get displaySubType => translateLegacyGearTerm(subType);

  List<String> get displayDefaultSports =>
    defaultSports.map(translateLegacyGearTerm).toList();

  String get brandModelSubtitle {
    final parts = [
      if (brand.trim().isNotEmpty) brand.trim(),
      if (model.trim().isNotEmpty) model.trim(),
    ];
    return parts.isEmpty ? displaySubType : parts.join(' • ');
  }

  String get formattedDistance {
    if (currentDistanceKm == currentDistanceKm.roundToDouble()) {
      return '${currentDistanceKm.toInt().withThousands} km';
    }
    return '${currentDistanceKm.toStringAsFixed(1)} km';
  }

  double? get wearProgressRatio {
    if (maxDistanceKm == null || maxDistanceKm! <= 0) return null;
    return (currentDistanceKm / maxDistanceKm!).clamp(0.0, 1.0);
  }

  bool get isReplacementDue {
    if (maxDistanceKm == null || maxDistanceKm! <= 0) return false;
    return currentDistanceKm >= maxDistanceKm!;
  }

  bool get isHighWear {
    final ratio = wearProgressRatio;
    if (ratio == null) return false;
    return ratio >= 0.8 && !isReplacementDue;
  }

  double? get remainingDistanceKm {
    if (maxDistanceKm == null || maxDistanceKm! <= 0) return null;
    return (maxDistanceKm! - currentDistanceKm).clamp(
      0.0,
      maxDistanceKm!.toDouble(),
    );
  }

  String get wearStatusLabel {
    if (isRetired) return 'Archived';
    if (isReplacementDue) return 'Replace Soon';
    if (isHighWear) return 'High Wear';
    if (maxDistanceKm != null) return 'Optimal';
    return 'Active';
  }

  AthleteGear copyWith({
    String? id,
    GearCategory? category,
    String? nickname,
    String? subType,
    String? brand,
    String? model,
    List<String>? defaultSports,
    double? weightKg,
    bool clearWeightKg = false,
    int? maxDistanceKm,
    bool clearMaxDistanceKm = false,
    int? batteryHours,
    bool clearBatteryHours = false,
    double? currentDistanceKm,
    String? notes,
    bool? isRetired,
    DateTime? createdAt,
  }) {
    return AthleteGear(
      id: id ?? this.id,
      category: category ?? this.category,
      nickname: nickname ?? this.nickname,
      subType: subType ?? this.subType,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      defaultSports: defaultSports ?? this.defaultSports,
      weightKg: clearWeightKg ? null : (weightKg ?? this.weightKg),
      maxDistanceKm:
        clearMaxDistanceKm ? null : (maxDistanceKm ?? this.maxDistanceKm),
      batteryHours:
        clearBatteryHours ? null : (batteryHours ?? this.batteryHours),
      currentDistanceKm: currentDistanceKm ?? this.currentDistanceKm,
      notes: notes ?? this.notes,
      isRetired: isRetired ?? this.isRetired,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name,
      'nickname': nickname,
      'subType': subType,
      'brand': brand,
      'model': model,
      'defaultSports': defaultSports,
      'weightKg': weightKg,
      'maxDistanceKm': maxDistanceKm,
      'batteryHours': batteryHours,
      'currentDistanceKm': currentDistanceKm,
      'notes': notes,
      'isRetired': isRetired,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AthleteGear.fromJson(Map<String, dynamic> json) {
    final String categoryName = json['category'] as String? ?? 'bike';
    final GearCategory parsedCategory = GearCategory.values.firstWhere(
      (c) => c.name == categoryName,
      orElse: () => GearCategory.bike,
    );

    return AthleteGear(
      id: json['id'] as String,
      category: parsedCategory,
      nickname: json['nickname'] as String? ?? '',
      subType: json['subType'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      model: json['model'] as String? ?? '',
      defaultSports: (json['defaultSports'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList(),
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      maxDistanceKm: (json['maxDistanceKm'] as num?)?.toInt(),
      batteryHours: (json['batteryHours'] as num?)?.toInt(),
      currentDistanceKm: (json['currentDistanceKm'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String? ?? '',
      isRetired: json['isRetired'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
        DateTime.now(),
    );
  }
}