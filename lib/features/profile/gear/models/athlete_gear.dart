import 'package:flutter/material.dart';

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
        return 'Sepeda';
      case GearCategory.shoes:
        return 'Sepatu';
      case GearCategory.wearable:
        return 'Jam GPS & Sensor';
      case GearCategory.swim:
        return 'Perlengkapan Renang';
    }
  }

  String get sectionHeader {
    switch (this) {
      case GearCategory.bike:
        return 'SEPEDA';
      case GearCategory.shoes:
        return 'SEPATU';
      case GearCategory.wearable:
        return 'JAM GPS & SENSOR';
      case GearCategory.swim:
        return 'PERLENGKAPAN RENANG';
    }
  }

  String get retiredLabel {
    switch (this) {
      case GearCategory.bike:
        return 'Sepeda yang Dipensiunkan';
      case GearCategory.shoes:
        return 'Sepatu Pensiun';
      case GearCategory.wearable:
        return 'Perangkat yang Dipensiunkan';
      case GearCategory.swim:
        return 'Alat Renang yang Dipensiunkan';
    }
  }

  String get subTypeFieldLabel {
    switch (this) {
      case GearCategory.bike:
        return 'Jenis Sepeda';
      case GearCategory.shoes:
        return 'Jenis Sepatu';
      case GearCategory.wearable:
        return 'Jenis Perangkat';
      case GearCategory.swim:
        return 'Jenis Alat Renang';
    }
  }

  String get sportFilterGroupTitle {
    switch (this) {
      case GearCategory.bike:
        return 'Olahraga Sepeda';
      case GearCategory.shoes:
        return 'Olahraga Lari & Jalan';
      case GearCategory.wearable:
        return 'Olahraga Multi-Sensor';
      case GearCategory.swim:
        return 'Olahraga Air & Renang';
    }
  }

  IconData get icon {
    switch (this) {
      case GearCategory.bike:
        return Icons.pedal_bike;
      case GearCategory.shoes:
        return Icons.directions_run;
      case GearCategory.wearable:
        return Icons.watch;
      case GearCategory.swim:
        return Icons.pool;
    }
  }

  List<String> get defaultSportsOptions {
    switch (this) {
      case GearCategory.bike:
        return const [
          'Bersepeda',
          'Bersepeda Gunung',
          'Medan Kerikil',
          'Bersepeda Virtual',
          'Bersepeda E-Bike',
          'Perjalanan Sepeda Elektrik Gunung',
          'Handcycle',
          'Velomobile',
        ];
        case GearCategory.shoes:
        return const [
          'Berlari',
          'Lari Trail',
          'Lari Virtual',
          'Berjalan',
          'Mendaki',
        ];
        case GearCategory.wearable:
        return const [
          'Berlari',
          'Bersepeda',
          'Berenang',
          'Lari Trail',
          'Mendaki',
          'Triathlon',
          'Latihan Kebugaran',
        ];
        case GearCategory.swim:
        return const [
          'Berenang',
          'Renang Perairan Terbuka',
          'Triathlon',
          'Akuatlon',
        ];
    }
  }

  List<String> get subTypeOptions {
    switch (this) {
      case GearCategory.bike:
        return const [
          'Sepeda Gunung',
          'Sepeda Cross',
          'Sepeda Balap',
          'Sepeda TT',
          'Bersepeda Medan Kerikil',
          'Sepeda E-Bike',
          'Sepeda Lipat / Kota',
        ];
        case GearCategory.shoes:
        return const [
          'Lari Jalan Raya (Road)',
          'Lari Trail',
          'Sepatu Lomba (Carbon / Racing)',
          'Latihan Harian (Daily Trainer)',
          'Jalan Santai & Mendaki',
        ];
        case GearCategory.wearable:
        return const [
          'Jam Tangan GPS',
          'Sensor Detak Jantung (HRM)',
          'Bike Computer GPS',
          'Power Meter',
          'Running Dynamics Pod',
        ];
        case GearCategory.swim:
        return const [
          'Kacamata Renang (Goggles)',
          'Wetsuit Open Water',
          'Sirip Renang (Fins)',
          'Hand Paddles & Pull Buoy',
          'Jam / Pelampung Renang',
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

  String get brandModelSubtitle {
    final parts = [
      if (brand.trim().isNotEmpty) brand.trim(),
      if (model.trim().isNotEmpty) model.trim(),
    ];
    return parts.isEmpty ? subType : parts.join(' • ');
  }

  String get formattedDistance {
    if (currentDistanceKm == currentDistanceKm.roundToDouble()) {
      return '${currentDistanceKm.toInt()} km';
    }
    return '${currentDistanceKm.toStringAsFixed(1).replaceAll('.', ',')} km';
  }

  double? get wearProgressRatio {
    if (maxDistanceKm == null || maxDistanceKm! <= 0) return null;
    return (currentDistanceKm / maxDistanceKm!).clamp(0.0, 1.0);
  }

  bool get isReplacementDue {
    if (maxDistanceKm == null || maxDistanceKm! <= 0) return false;
    return currentDistanceKm >= maxDistanceKm!;
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



