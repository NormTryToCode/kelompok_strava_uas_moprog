import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../models/athlete_gear.dart';
import '../providers/athlete_gear_provider.dart';
import '../widgets/gear_picker_sheets.dart';
import '../widgets/profile_labeled_field.dart';
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
      _defaultSports = List<String>.from(existing.defaultSports);
      _subType = existing.subType;
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
      builder: (_) => GearCategoryPickerSheet(selectedCategory: _category),
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
      builder: (_) => DefaultSportsFilterSheet(
        category: _category,
        initialSelected: _defaultSports,
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
      builder: (_) => GearSubTypeSheet(
        category: _category,
        selectedSubType: _subType,
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
      MaterialPageRoute(
        builder: (_) => GearBrandSearchScreen(
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
      builder: (_) => GearDistanceLimitSheet(
        category: _category,
        selectedKm: _maxDistanceKm,
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        _maxDistanceKm = (picked == -1) ? null : picked;
      });
    }
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          message,
          style: const TextStyle(color: Styles.tabActive),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_subType.trim().isEmpty) {
      _showValidationError('Pilih ${_category.subTypeFieldLabel} terlebih dahulu.');
      return;
    }
    if (_brand.trim().isEmpty) {
      _showValidationError('Pilih atau tambahkan Merek terlebih dahulu.');
      return;
    }
    if (_modelController.text.trim().isEmpty) {
      _showValidationError('Masukkan nama Model perlengkapan terlebih dahulu.');
      return;
    }

    double? parsedWeight;
    if (_category == GearCategory.bike) {
      final rawWeight = _weightController.text.trim().replaceAll(',', '.');
      parsedWeight = double.tryParse(rawWeight);
      if (parsedWeight == null || parsedWeight <= 0) {
        _showValidationError('Berat sepeda (kg) wajib diisi dengan angka valid.');
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
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  Future<void> _confirmAndDelete() async {
    final existing = widget.existingGear;
    if (existing == null) return;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Styles.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.field),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Anda yakin ingin menghapus item ini?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Styles.tabActive,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Data "${existing.displayName}" akan dihapus permanen dari daftar perlengkapan Anda.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Styles.tabInactive,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      child: const Text(
                        'Batalkan',
                        style: TextStyle(color: Styles.tabInactive),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      child: const Text(
                        'Hapus',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Styles.accent,
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
      Navigator.of(context).pop(true);
    }
  }

  String get _defaultSportsDisplayText {
    if (_defaultSports.isEmpty) return 'Pilih olahraga default';
    return _defaultSports.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Styles.background,
        appBar: AppBar(
          backgroundColor: Styles.background,
          foregroundColor: Styles.tabActive,
          title: Text(
            _isEditMode
              ? 'Edit ${_category.label}'
              : 'Tambahkan Perlengkapan',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Styles.tabActive,
            ),
          ),
          actions: [
            TextButton(
              onPressed: _handleSave,
              child: const Text(
                'SIMPAN',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Styles.accent,
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
                if (!_isEditMode) ...[
                  ProfileLabeledField(
                    label: 'Jenis Perlengkapan',
                    valueText: _category.label,
                    onTap: _selectCategory,
                  ),
                  const SizedBox(height: 14),
                ],
                ProfileLabeledField(
                  label: 'Olahraga Default',
                  valueText: _defaultSportsDisplayText,
                  onTap: _selectDefaultSports,
                ),
                const SizedBox(height: 14),
                ProfileLabeledField(
                  label: 'Nama Panggilan',
                  controller: _nicknameController,
                  placeholder: 'Contoh: ${_category == GearCategory.bike 
                    ? 'BMX Saya' 
                    : _category == GearCategory.shoes 
                      ? 'Sepatu Lomba 10K' 
                      : 'Perangkat Utama'}',
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 14),
                ProfileLabeledField(
                  label: _category.subTypeFieldLabel,
                  valueText: _subType.isEmpty
                    ? 'Pilih ${_category.subTypeFieldLabel}'
                    : _subType,
                  onTap: _selectSubType,
                ),
                const SizedBox(height: 14),
                ProfileLabeledField(
                  label: 'Merek',
                  valueText: _brand.isEmpty ? 'Cari atau tambah merek' : _brand,
                  onTap: _selectBrand,
                ),
                const SizedBox(height: 14),
                ProfileLabeledField(
                  label: 'Model',
                  controller: _modelController,
                  placeholder: _category == GearCategory.bike
                    ? 'Contoh: Cascade 4 / Tarmac SL8'
                    : _category == GearCategory.shoes
                      ? 'Contoh: GoWalk / Alphafly 3'
                      : 'Masukkan model perlengkapan',
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 14),
                if (_category == GearCategory.bike) ...[
                  ProfileLabeledField(
                    label: 'Berat (kg) *Wajib',
                    controller: _weightController,
                    placeholder: 'Contoh: 12,5',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                  ),
                  const SizedBox(height: 14),
                ],
                if (_category == GearCategory.shoes ||
                    _category == GearCategory.swim) ...[
                  ProfileLabeledField(
                    label: _category == GearCategory.shoes
                      ? 'Beri tahu saya saat mencapai (Opsional)'
                      : 'Target Jarak Maksimal (Opsional)',
                    valueText: _maxDistanceKm != null
                      ? '$_maxDistanceKm km'
                      : 'Opsional (Ketuk untuk memilih km)',
                    onTap: _selectMaxDistance,
                  ),
                  const SizedBox(height: 14),
                ],
                if (_category == GearCategory.wearable) ...[
                  ProfileLabeledField(
                    label: 'Daya Tahan Baterai (jam) - Opsional',
                    controller: _batteryController,
                    placeholder: 'Contoh: 36',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const SizedBox(height: 14),
                ],
                ProfileLabeledField(
                  label: 'Catatan (Opsional)',
                  controller: _notesController,
                  placeholder: 'Tambahkan catatan khusus perlengkapan ini...',
                  textCapitalization: TextCapitalization.sentences,
                ),
                if (_isEditMode) ...[
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Radii.button),
                        ),
                      ),
                      onPressed: _confirmAndDelete,
                      icon: const Icon(Icons.delete_outline),
                      label: Text(
                        'Hapus ${_category.label}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
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