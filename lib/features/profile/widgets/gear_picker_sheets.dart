import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../models/athlete_gear.dart';

class GearCategoryPickerSheet extends StatelessWidget {
  final GearCategory selectedCategory;

  const GearCategoryPickerSheet({
    super.key,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Styles.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.card)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Styles.inactive,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Jenis Perlengkapan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Styles.tabActive,
            ),
          ),
          const SizedBox(height: 12),
          ...GearCategory.values.map((category) {
            final bool isSelected = category == selectedCategory;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(Radii.chip),
                onTap: () => Navigator.of(context).pop(category),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        category.icon,
                        color: isSelected ? Styles.accent : Styles.tabInactive,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          category.label,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                            color: isSelected
                              ? Styles.accent
                              : Styles.tabActive,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check, color: Styles.accent),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
} 

class DefaultSportsFilterSheet extends StatefulWidget {
  final GearCategory category;
  final List<String> initialSelected;

  const DefaultSportsFilterSheet({
    super.key,
    required this.category,
    required this.initialSelected,
  });

  @override
  State<DefaultSportsFilterSheet> createState() =>
    _DefaultSportsFilterSheetState();
}

class _DefaultSportsFilterSheetState extends State<DefaultSportsFilterSheet> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelected.toSet();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> allSports = widget.category.defaultSportsOptions;
    final bool isAllSelected =
      allSports.isNotEmpty && _selected.length == allSports.length;

    return Container(
      decoration: const BoxDecoration(
        color: Styles.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.card)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Styles.inactive,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter berdasarkan Olahraga',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Styles.tabActive,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    if (isAllSelected) {
                      _selected.clear();
                    } else {
                      _selected = allSports.toSet();
                    }
                  });
                },
                child: Text(
                  isAllSelected ? 'Hapus Semua' : 'Pilih Semua',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Styles.accent,
                  ),
                ),
              ),
            ],
          ),
          Text(
            widget.category.sportFilterGroupTitle,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Styles.tabInactive,
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: allSports.map((sport) {
                  final bool checked = _selected.contains(sport);
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(Radii.chip),
                      onTap: () {
                        setState(() {
                          if (checked) {
                            _selected.remove(sport);
                          } else {
                            _selected.add(sport);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              widget.category.icon,
                              size: 20,
                              color:
                                checked ? Styles.accent : Styles.tabInactive,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                sport,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Styles.tabActive,
                                ),
                              ),
                            ),
                            Icon(
                              checked
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                              color:
                                checked ? Styles.accent : Styles.tabInactive,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Styles.tabActive,
                    side: const BorderSide(color: Palette.cardBorder),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.accent,
                    foregroundColor: Styles.tabActive,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () =>
                    Navigator.of(context).pop(_selected.toList()),
                  child: Text('Terapkan (${_selected.length})'),
                  ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GearSubTypeSheet extends StatelessWidget {
  final GearCategory category;
  final String selectedSubType;

  const GearSubTypeSheet({
    super.key,
    required this.category,
    required this.selectedSubType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Styles.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.card)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Styles.inactive,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            category.subTypeFieldLabel,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Styles.tabActive,
            ),
          ),
          const SizedBox(height: 10),
          ...category.subTypeOptions.map((option) {
            final bool isSelected = option == selectedSubType;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(Radii.chip),
                onTap: () => Navigator.of(context).pop(option),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        option,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                          color:
                            isSelected ? Styles.accent : Styles.tabActive,
                        ),
                      ),
                      Icon(
                        isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                        color: isSelected ? Styles.accent : Styles.tabInactive,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class GearDistanceLimitSheet extends StatelessWidget {
  final GearCategory category;
  final int? selectedKm;

  const GearDistanceLimitSheet({
    super.key,
    required this.category,
    required this.selectedKm,
  });

  @override
  Widget build(BuildContext context) {
    final List<int> presets = category.maxDistancePresets;

    return Container(
      decoration: const BoxDecoration(
        color: Styles.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.card)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Styles.inactive,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Target Batas Penggantian',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Styles.tabActive,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Atur target kilometer maksimal untuk memantau masa pakai perlengkapan.',
            style: TextStyle(fontSize: 12, color: Styles.tabInactive),
          ),
          const SizedBox(height: 12),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(Radii.chip),
              onTap: () => Navigator.of(context).pop(-1),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tidak diatur',
                      style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: selectedKm == null
                          ? Styles.accent
                          : Styles.tabInactive,
                      ),
                    ),
                    if (selectedKm == null)
                      const Icon(Icons.check, color: Styles.accent),
                  ],
                ),
              ),
            ),
          ),
          const Divider(color: Styles.inactive, height: 1),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: presets.map((km) {
                  final bool isSelected = selectedKm == km;
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(Radii.chip),
                      onTap: () => Navigator.of(context).pop(km),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 14,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$km km',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                                color: isSelected
                                  ? Styles.accent
                                  : Styles.tabActive,
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check, color: Styles.accent),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



