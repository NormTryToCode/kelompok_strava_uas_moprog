import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../../shared/utils/profile_page_route.dart';
import '../../shared/utils/profile_snackbar_helper.dart';
import '../../shared/widgets/profile_labeled_field.dart';
import '../models/athlete_gear.dart';
import '../providers/athlete_gear_provider.dart';
import '../widgets/gear_picker_sheets.dart';
import 'gear_brand_search_screen.dart';

class GearFormScreen extends ConsumerStatefulWidget {
  final AthleteGear? existingGear;
  final GearCategory initialCategory;

  const GearFormScreen({
    super.key,
    this.existingGear,
    this.initialCategory = GearCategory.bike,
  });

  @override
  ConsumerState<GearFormScreen> createState() => _GearFormScreenState();
}

class _GearFormScreenState extends ConsumerState<GearFormScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _batteryController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  late GearCategory _category;
  late List<String> _defaultSports;
  late String _subType;
  late String _brand;
  int? _maxDistanceKm;

  bool get _isEditMode => widget.existingGear != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingGear;
    if (existing != null) {
      _category = existing.category;
      _defaultSports = existing.displayDefaultSports;
      _subType = existing.displaySubType;
      _brand = existing.brand;
      _maxDistanceKm = existing.maxDistanceKm;
      _nicknameController.text = existing.nickname;
      _modelController.text = existing.model;
      _notesController.text = existing.notes;
      if (existing.weightKg != null) {
        _weightController.text = existing.weightKg!.toStringAsFixed(1);
      }
      if (existing.batteryHours != null) {
        _batteryController.text = existing.batteryHours.toString();
      }
    } else {
      _category = widget.initialCategory;
      _defaultSports = [];
      _subType = '';
      _brand = '';
      _maxDistanceKm = null;
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _modelController.dispose();
    _weightController.dispose();
    _batteryController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectCategory() async {
    if (_isEditMode) return;
    final GearCategory? picked = await showModalBottomSheet<GearCategory>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Theme(
        data: profileDarkTheme,
        child: GearCategoryPickerSheet(selectedCategory: _category),
      ),
    );
    if (picked != null && picked != _category && mounted) {
      setState(() {
        _category = picked;
        _defaultSports = [];
        _subType = '';
        _brand = '';
        _maxDistanceKm = null;
        _weightController.clear();
        _batteryController.clear();
      });
    }
  }

  Future<void> _selectDefaultSports() async {
    final List<String>? picked = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Theme(
        data: profileDarkTheme,
        child: DefaultSportsFilterSheet(
          category: _category,
          initialSelected: _defaultSports,
        ),
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        _defaultSports = picked;
      });
    }
  }

  Future<void> _selectSubType() async {
    final String? picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Theme(
        data: profileDarkTheme,
        child: GearSubTypeSheet(
          category: _category,
          selectedSubType: _subType,
        ),
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        _subType = picked;
      });
    }
  }

  Future<void> _selectBrand() async {
    final String? picked = await Navigator.of(context).push<String>(
      buildProfileRoute<String>(
        GearBrandSearchScreen(
          category: _category,
          initialBrand: _brand,
        ),
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        _brand = picked;
      });
    }
  }

  Future<void> _selectMaxDistance() async {
    final int? picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Theme(
        data: profileDarkTheme,
        child: GearDistanceLimitSheet(
          category: _category,
          selectedKm: _maxDistanceKm,
        ),
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        _maxDistanceKm = (picked == -1) ? null : picked;
      });
    }
  }

  Future<void> _handleSave() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_subType.trim().isEmpty) {
      ProfileSnackbarHelper.showError(
        context,
        'Please select a ${_category.subTypeFieldLabel.toLowerCase()} first.',
      );
      return;
    }
    if (_brand.trim().isEmpty) {
      ProfileSnackbarHelper.showError(
        context,
        'Please choose or add a brand first.',
      );
      return;
    }
    if (_modelController.text.trim().isEmpty) {
      ProfileSnackbarHelper.showError(
        context,
        'Please enter the equipment model name.',
      );
      return;
    }

    double? parsedWeight;
    if (_category == GearCategory.bike) {
      final rawWeight = _weightController.text.trim().replaceAll(',', '.');
      parsedWeight = double.tryParse(rawWeight);
      if (parsedWeight == null || parsedWeight <= 0) {
        ProfileSnackbarHelper.showError(
          context,
          'Please enter a valid frame weight (kg).',
        );
        return;
      }
    }

    int? parsedBattery;
    if (_category == GearCategory.wearable &&
      _batteryController.text.trim().isNotEmpty) {
        parsedBattery = int.tryParse(_batteryController.text.trim());
    }

    final notifier = ref.read(athleteGearProvider.notifier);

    if (_isEditMode) {
      final updated = widget.existingGear!.copyWith(
        nickname: _nicknameController.text.trim(),
        subType: _subType,
        brand: _brand,
        model: _modelController.text.trim(),
        defaultSports: _defaultSports,
        weightKg: parsedWeight,
        clearWeightKg: _category != GearCategory.bike,
        maxDistanceKm: _maxDistanceKm,
        clearMaxDistanceKm: _maxDistanceKm == null,
        batteryHours: parsedBattery,
        clearBatteryHours: parsedBattery == null,
        notes: _notesController.text.trim(),
      );
      await notifier.updateGear(updated);
      if (!mounted) return;
      ProfileSnackbarHelper.showSuccess(
        context,
        '"${updated.displayName}" updated in Gear Locker.',
      );
    } else {
      final newGear = AthleteGear(
        id: 'gear_${DateTime.now().millisecondsSinceEpoch}',
        category: _category,
        nickname: _nicknameController.text.trim(),
        subType: _subType,
        brand: _brand,
        model: _modelController.text.trim(),
        defaultSports: _defaultSports,
        weightKg: parsedWeight,
        maxDistanceKm: _maxDistanceKm,
        batteryHours: parsedBattery,
        notes: _notesController.text.trim(),
        createdAt: DateTime.now(),
      );
      await notifier.addGear(newGear);
      if (!mounted) return;
      ProfileSnackbarHelper.showSuccess(
        context,
        '"${newGear.displayName}" registered in Gear Locker!',
      );
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  Future<void> _confirmAndDelete() async {
    final existing = widget.existingGear;
    if (existing == null) return;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierColor: const Color.fromARGB(210, 7, 6, 12),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Styles.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.card),
            side: const BorderSide(color: Styles.borderStrong, width: 1.2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delete Equipment?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Styles.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '"${existing.displayName}" and its tracked mileage will be permanently removed from your locker.',
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.4,
                    color: Styles.textSecondary,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: Styles.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.danger,
                        foregroundColor: Styles.textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Radii.chip),
                        ),
                      ),
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed == true) {
      await ref.read(athleteGearProvider.notifier).deleteGear(existing.id);
      if (!mounted) return;
      ProfileSnackbarHelper.showInfo(
        context,
        '"${existing.displayName}" removed from locker.',
      );
      Navigator.of(context).pop(true);
    }
  }

  String get _defaultSportsDisplayText {
    if (_defaultSports.isEmpty) return 'Tap to assign default sports';
    return _defaultSports.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Styles.canvas,
        appBar: AppBar(
          backgroundColor: Styles.canvas,
          foregroundColor: Styles.textPrimary,
          surfaceTintColor: Colors.transparent,
          title: Text(
            _isEditMode ? 'Edit ${_category.label}' : 'Register Equipment',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Styles.textPrimary,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Styles.surfaceHighlight,
                  foregroundColor: Styles.primaryLight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Styles.primary),
                  ),
                ),
                onPressed: _handleSave,
                child: const Text(
                  'SAVE',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeading(title: '01  •  CLASSIFICATION'),
                const SizedBox(height: 10),
                if (!_isEditMode) ...[
                  ProfileLabeledField(
                    label: 'Equipment Category',
                    valueText: _category.label,
                    onTap: _selectCategory,
                  ),
                  const SizedBox(height: 12),
                ],
                ProfileLabeledField(
                  label: _category.subTypeFieldLabel,
                  valueText: _subType.isEmpty
                    ? 'Select ${_category.subTypeFieldLabel.toLowerCase()}'
                    : _subType,
                  onTap: _selectSubType,
                ),
                const SizedBox(height: 12),
                ProfileLabeledField(
                  label: 'Assigned Sports',
                  valueText: _defaultSportsDisplayText,
                  onTap: _selectDefaultSports,
                ),
                const SizedBox(height: 22),
                const _SectionHeading(title: '02  •  IDENTITY & SPECS'),
                const SizedBox(height: 10),
                ProfileLabeledField(
                  label: 'Custom Nickname (Optional)',
                  controller: _nicknameController,
                  placeholder: 'e.g. ${_category == GearCategory.bike
                    ? 'Stealth Aero Rig'
                    : _category == GearCategory.shoes
                      ? 'Race Day Carbon'
                      : 'Primary Tracker'}',
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                ProfileLabeledField(
                  label: 'Brand',
                  valueText: _brand.isEmpty
                    ? 'Search or add a custom brand'
                    : _brand,
                  onTap: _selectBrand,
                ),
                const SizedBox(height: 12),
                ProfileLabeledField(
                  label: 'Model Name',
                  controller: _modelController,
                  placeholder: _category == GearCategory.bike
                    ? 'e.g. Tarmac SL8 / Aeroad CFR'
                    : _category == GearCategory.shoes
                      ? 'e.g. Alphafly 3 / Superblast 2'
                      : 'Enter model designation',
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                if (_category == GearCategory.bike) ...[
                  ProfileLabeledField(
                    label: 'Frame Weight (kg)',
                    controller: _weightController,
                    placeholder: 'e.g. 7.8',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                if (_category == GearCategory.wearable) ...[
                  ProfileLabeledField(
                    label: 'Battery Life (hours)',
                    controller: _batteryController,
                    placeholder: 'e.g. 36',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 10),
                const _SectionHeading(title: '03  •  WEAR-LIFE & NOTES'),
                const SizedBox(height: 10),
                if (_category == GearCategory.shoes ||
                  _category == GearCategory.swim) ...[
                    ProfileLabeledField(
                      label: 'Wear-Life Alert Threshold',
                      valueText: _maxDistanceKm != null
                        ? '$_maxDistanceKm km lifespan'
                        : 'Tap to set mileage alert',
                      onTap: _selectMaxDistance,
                    ),
                    const SizedBox(height: 12),
                ],
                ProfileLabeledField(
                  label: 'Maintenance Notes',
                  controller: _notesController,
                  placeholder: 'Tire pressure, chain lube log, or fit notes...',
                  textCapitalization: TextCapitalization.sentences,
                ),
                if (_isEditMode) ...[
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Styles.danger.withValues(alpha: 0.1),
                        foregroundColor: Styles.danger,
                        side: const BorderSide(color: Styles.danger),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Radii.button),
                        ),
                      ),
                      onPressed: _confirmAndDelete,
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: Text(
                        'Delete ${_category.label}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;

  const _SectionHeading({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 13,
          decoration: BoxDecoration(
            gradient: Styles.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
            color: Styles.primaryLight,
          ),
        ),
      ],
    );
  }
}