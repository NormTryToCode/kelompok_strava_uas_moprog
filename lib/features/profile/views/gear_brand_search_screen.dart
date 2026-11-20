import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
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

  @override
  Widget build(BuildContext context) {
    final customBrandsMap = ref.watch(customBrandsProvider);
    final customList = customBrandsMap[widget.category.name] ?? const [];

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

    return Scaffold(
      backgroundColor: Styles.background,
      appBar: AppBar(
        backgroundColor: Styles.background,
        foregroundColor: Styles.tabActive,
        title: Text(
          'Merek ${widget.category.label}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Styles.tabActive,
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
                style: const TextStyle(color: Styles.tabActive, fontSize: 15),
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari merek atau ketik merek baru...',
                  hintStyle: const TextStyle(color: Styles.tabInactive),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Styles.tabInactive,
                  ),
                  suffixIcon: _query.isNotEmpty
                    ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Styles.tabInactive,
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
                  fillColor: Palette.fieldFill,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Radii.chip),
                    borderSide: const BorderSide(color: Palette.cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Radii.chip),
                    borderSide: const BorderSide(color: Styles.accent),
                  ),
                ),
              ),
            ),
            if (trimmedQuery.isNotEmpty && !hasExactMatch)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Material(
                  color: Palette.selectedFill,
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
                        border: Border.all(color: Styles.accent),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.add_circle_outline,
                            color: Styles.accent,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Tambahkan merek "$trimmedQuery"',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Styles.tabActive,
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
                          fontSize: 14,
                          color: Styles.tabInactive,
                        ),
                      ),
                    ),
                  )
                  : ListView.separated(
                    itemCount: filteredBrands.length,
                    separatorBuilder: (_, _) => const Divider(
                      height: 1,
                      color: Styles.inactive,
                    ),
                    itemBuilder: (context, index) {
                      final brand = filteredBrands[index];
                      final bool isSelected = brand.toLowerCase() ==
                        widget.initialBrand.trim().toLowerCase();
                      return ListTile(
                        onTap: () => Navigator.of(context).pop(brand),
                        title: Text(
                          brand,
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
                        trailing: isSelected
                          ? const Icon(Icons.check, color: Styles.accent)
                          : null,
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

    


