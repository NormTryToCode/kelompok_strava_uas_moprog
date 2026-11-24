import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

import '../models/athlete_gear.dart';

class GearCategoryPickerSheet extends StatelessWidget {
  final GearCategory selectedCategory;

  const GearCategoryPickerSheet({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Styles.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.card)),
        border: Border(
          top: BorderSide(color: Styles.borderStrong, width: 1.2),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Styles.borderStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Jenis Perlengkapan',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Styles.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...GearCategory.values.map((category) {
            final bool isSelected = category == selectedCategory;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Material(
                color: isSelected
                  ? Styles.surfaceHighlight.withValues(alpha: 0.75)
                  : Colors.transparent,
                borderRadius: BorderRadius.circular(Radii.chip),
                child: InkWell(
                  borderRadius: BorderRadius.circular(Radii.chip),
                  onTap: () => Navigator.of(context).pop(category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Radii.chip),
                      border: Border.all(
                        color: isSelected
                          ? Styles.primary.withValues(alpha: 0.6)
                          : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          category.icon,
                          size: 22,
                          color: isSelected
                            ? Styles.primaryLight
                            : Styles.textSecondary,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            category.label,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                              color: isSelected
                                ? Styles.primaryLight
                                : Styles.textPrimary,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_rounded,
                            color: Styles.primaryLight,
                          ),
                      ],
                    ),
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
        border: Border(
          top: BorderSide(color: Styles.borderStrong, width: 1.2),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Styles.borderStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Filter berdasarkan Olahraga',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Styles.textPrimary,
                  ),
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
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Styles.primaryLight,
                  ),
                ),
              ),
            ],
          ),
          Text(
            widget.category.sportFilterGroupTitle,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Styles.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: allSports.map((sport) {
                  final bool checked = _selected.contains(sport);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Material(
                      color: checked
                        ? Styles.surfaceHighlight.withValues(alpha: 0.55)
                        : Colors.transparent,
                      borderRadius: BorderRadius.circular(Radii.chip),
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
                            horizontal: 10,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                widget.category.icon,
                                size: 21,
                                color: checked
                                  ? Styles.primaryLight
                                  : Styles.textSecondary,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  sport,
                                  style: TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: checked
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                    color: Styles.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                checked
                                  ? Icons.check_box_rounded
                                  : Icons.check_box_outline_blank_rounded,
                                size: 23,
                                color: checked
                                  ? Styles.primaryLight
                                  : Styles.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Styles.surfaceElevated,
                    foregroundColor: Styles.textPrimary,
                    side: const BorderSide(color: Styles.borderStrong),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.button),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Batal',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Styles.primaryDark, Styles.primary],
                    ),
                    borderRadius: BorderRadius.circular(Radii.button),
                    boxShadow: Styles.glow(intensity: 0.3, blur: 14),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Styles.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Radii.button),
                      ),
                    ),
                    onPressed: () =>
                        Navigator.of(context).pop(_selected.toList()),
                    child: Text(
                      'Terapkan (${_selected.length})',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
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
        border: Border(
          top: BorderSide(color: Styles.borderStrong, width: 1.2),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Styles.borderStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            category.subTypeFieldLabel,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Styles.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: category.subTypeOptions.map((option) {
                  final bool isSelected = option == selectedSubType;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Material(
                      color: isSelected
                        ? Styles.surfaceHighlight.withValues(alpha: 0.7)
                        : Colors.transparent,
                      borderRadius: BorderRadius.circular(Radii.chip),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(Radii.chip),
                        onTap: () => Navigator.of(context).pop(option),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 14,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                    color: isSelected
                                      ? Styles.primaryLight
                                      : Styles.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                                color: isSelected
                                  ? Styles.primaryLight
                                  : Styles.textSecondary,
                              ),
                            ],
                          ),
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
        border: Border(
          top: BorderSide(color: Styles.borderStrong, width: 1.2),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Styles.borderStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Target Batas Penggantian',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Styles.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Atur target kilometer maksimal untuk memantau masa pakai perlengkapan.',
            style: TextStyle(
              fontSize: 13.5,
              height: 1.35,
              color: Styles.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          Material(
            color: selectedKm == null
              ? Styles.surfaceHighlight.withValues(alpha: 0.6)
              : Colors.transparent,
            borderRadius: BorderRadius.circular(Radii.chip),
            child: InkWell(
              borderRadius: BorderRadius.circular(Radii.chip),
              onTap: () => Navigator.of(context).pop(-1),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 13,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tidak diatur',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontStyle: FontStyle.italic,
                        fontWeight: selectedKm == null
                          ? FontWeight.w700
                          : FontWeight.w500,
                        color: selectedKm == null
                          ? Styles.primaryLight
                          : Styles.textSecondary,
                      ),
                    ),
                    if (selectedKm == null)
                      const Icon(
                        Icons.check_rounded,
                        color: Styles.primaryLight,
                      ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Divider(color: Styles.borderStrong, height: 1),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: presets.map((km) {
                  final bool isSelected = selectedKm == km;
                  return Material(
                    color: isSelected
                      ? Styles.surfaceHighlight.withValues(alpha: 0.65)
                      : Colors.transparent,
                    borderRadius: BorderRadius.circular(Radii.chip),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(Radii.chip),
                      onTap: () => Navigator.of(context).pop(km),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
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
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                                color: isSelected
                                  ? Styles.primaryLight
                                  : Styles.textPrimary,
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_rounded,
                                color: Styles.primaryLight,
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
        ],
      ),
    );
  }
}