import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

import '../../shared/utils/profile_snackbar_helper.dart';
import '../models/athlete_gear.dart';
import '../providers/athlete_gear_provider.dart';

class GearBrandSearchScreen extends ConsumerStatefulWidget {
  final GearCategory category;
  final String initialBrand;

  const GearBrandSearchScreen({
    super.key,
    required this.category,
    required this.initialBrand,
  });

  @override
  ConsumerState<GearBrandSearchScreen> createState() =>
    _GearBrandSearchScreenState();
}

class _GearBrandSearchScreenState extends ConsumerState<GearBrandSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  late String _selectedBrand;

  @override
  void initState() {
    super.initState();
    _selectedBrand = widget.initialBrand;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _selectCustomBrand(String brandName) async {
    final trimmed = brandName.trim();
    if (trimmed.isEmpty) return;

    await ref
      .read(customBrandsProvider.notifier)
      .addCustomBrand(widget.category, trimmed);

    if (!mounted) return;
    Navigator.of(context).pop(trimmed);
  }

  Future<void> _deleteCustomBrand(String brandName) async {
    await ref
      .read(customBrandsProvider.notifier)
      .removeCustomBrand(widget.category, brandName);

    if (!mounted) return;
    if (_selectedBrand.trim().toLowerCase() == brandName.toLowerCase()) {
      setState(() {
        _selectedBrand = '';
      });
    }

    ProfileSnackbarHelper.showInfo(
      context,
      'Merek "$brandName" berhasil dihapus.',
    );
  }

  Future<void> _showEditCustomBrandDialog(String oldBrand) async {
    final TextEditingController editController = TextEditingController(
      text: oldBrand,
    );

    final String? updatedName = await showDialog<String>(
      context: context,
      barrierColor: const Color.fromARGB(210, 7, 6, 12),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Styles.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.card),
            side: const BorderSide(color: Styles.borderStrong),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Nama Merek',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Styles.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Perbaiki ejaan merek yang ditambahkan sebelumnya.',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Styles.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: editController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  cursorColor: Styles.primaryLight,
                  style: const TextStyle(
                    color: Styles.textPrimary,
                    fontSize: 15.5,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama merek yang benar',
                    hintStyle: TextStyle(
                      color: Styles.textSecondary.withValues(alpha: 0.72),
                    ),
                    filled: true,
                    fillColor: Styles.fieldFill,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Radii.chip),
                      borderSide: const BorderSide(color: Styles.borderStrong),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Radii.chip),
                      borderSide: const BorderSide(
                        color: Styles.primaryLight,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text(
                        'Batalkan',
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
                        backgroundColor: Styles.primary,
                        foregroundColor: Styles.textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Radii.chip),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext)
                          .pop(editController.text.trim());
                      },
                      child: const Text(
                        'Simpan',
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

    editController.dispose();

    if (updatedName == null || updatedName.isEmpty || updatedName == oldBrand) {
      return;
    }

    await ref
      .read(customBrandsProvider.notifier)
      .updateCustomBrand(widget.category, oldBrand, updatedName);

    if (!mounted) return;
    if (_selectedBrand.trim().toLowerCase() == oldBrand.toLowerCase()) {
      setState(() {
        _selectedBrand = updatedName;
      });
    }

    ProfileSnackbarHelper.showSuccess(
      context,
      'Merek diubah menjadi "$updatedName".',
    );
  }

  @override
  Widget build(BuildContext context) {
    final customBrandsMap = ref.watch(customBrandsProvider);
    final customList = customBrandsMap[widget.category.name] ?? const [];
    final Set<String> presetLowerSet = widget.category.presetBrands
      .map((e) => e.toLowerCase())
      .toSet();

    final Set<String> mergedSet = {
      ...widget.category.presetBrands,
      ...customList,
    };
    final List<String> allBrands = mergedSet.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    final String trimmedQuery = _query.trim();
    final List<String> filteredBrands = trimmedQuery.isEmpty
      ? allBrands
      : allBrands
        .where(
          (brand) =>
            brand.toLowerCase().contains(trimmedQuery.toLowerCase()),
        )
        .toList();

    final bool hasExactMatch = trimmedQuery.isNotEmpty &&
        allBrands.any(
          (brand) => brand.toLowerCase() == trimmedQuery.toLowerCase(),
        );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, String? result) {
        if (didPop) return;
        Navigator.of(context).pop(_selectedBrand);
      },
      child: Scaffold(
        backgroundColor: Styles.canvas,
        appBar: AppBar(
          backgroundColor: Styles.canvas,
          foregroundColor: Styles.textPrimary,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Styles.textPrimary),
            onPressed: () => Navigator.of(context).pop(_selectedBrand),
          ),
          title: Text(
            'Merek ${widget.category.label}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Styles.textPrimary,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  cursorColor: Styles.primaryLight,
                  style: const TextStyle(
                    color: Styles.textPrimary,
                    fontSize: 15.5,
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (value) {
                    setState(() {
                      _query = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari merek atau ketik merek baru...',
                    hintStyle: TextStyle(
                      fontSize: 14.5,
                      color: Styles.textSecondary.withValues(alpha: 0.78),
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Styles.primaryLight,
                    ),
                    suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear_rounded,
                            color: Styles.textSecondary,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _query = '';
                            });
                          },
                        )
                      : null,
                    filled: true,
                    fillColor: Styles.fieldFill,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Radii.chip),
                      borderSide: const BorderSide(color: Styles.borderStrong),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Radii.chip),
                      borderSide: const BorderSide(
                        color: Styles.primaryLight,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              if (trimmedQuery.isNotEmpty && !hasExactMatch)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Material(
                    color: Styles.surfaceHighlight,
                    borderRadius: BorderRadius.circular(Radii.chip),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(Radii.chip),
                      onTap: () => _selectCustomBrand(trimmedQuery),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Radii.chip),
                          border: Border.all(color: Styles.primaryLight),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add_circle_outline_rounded,
                              color: Styles.primaryLight,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Tambahkan merek "$trimmedQuery"',
                                style: const TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.bold,
                                  color: Styles.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: filteredBrands.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'Merek "$trimmedQuery" belum terdaftar.\nKetuk tombol di atas untuk menambahkannya.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14.5,
                            height: 1.45,
                            color: Styles.textSecondary,
                          ),
                        ),
                      ),
                    )
                    : ListView.separated(
                        itemCount: filteredBrands.length,
                        separatorBuilder: (_, _) => const Divider(
                          height: 1,
                          color: Styles.divider,
                        ),
                        itemBuilder: (context, index) {
                          final brand = filteredBrands[index];
                          final bool isCustom = !presetLowerSet.contains(
                            brand.toLowerCase(),
                          );
                          final bool isSelected = brand.toLowerCase() ==
                            _selectedBrand.trim().toLowerCase();

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 2,
                            ),
                            onTap: () => Navigator.of(context).pop(brand),
                            title: Text(
                              brand,
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
                            subtitle: isCustom
                              ? const Text(
                                  'Merek kustom',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: Styles.secondary,
                                  ),
                                )
                              : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isCustom) ...[
                                  IconButton(
                                    tooltip: 'Edit ejaan merek',
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 20,
                                      color: Styles.textSecondary,
                                    ),
                                    onPressed: () =>
                                      _showEditCustomBrandDialog(brand),
                                  ),
                                  IconButton(
                                    tooltip: 'Hapus merek kustom',
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 20,
                                      color: Styles.danger,
                                    ),
                                    onPressed: () => _deleteCustomBrand(brand),
                                  ),
                                ],
                                if (isSelected)
                                  const Icon(
                                    Icons.check_rounded,
                                    color: Styles.primaryLight,
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}