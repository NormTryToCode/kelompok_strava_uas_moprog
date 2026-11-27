import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/record/models/record_sport_catalog.dart';

/// Opens a resizable modal sheet allowing the user to search and pick a sport.
Future<RecordSportItem?> showSportFilterSheet(
  BuildContext context, {
  required RecordSportItem selectedSport,
  List<RecordSportItem> topSports = const [],
}) {
  return showModalBottomSheet<RecordSportItem>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _SportFilterSheet(
      selectedSport: selectedSport,
      topSports: topSports,
    ),
  );
}

class _SportFilterSheet extends StatefulWidget {
  final RecordSportItem selectedSport;
  final List<RecordSportItem> topSports;

  const _SportFilterSheet({
    required this.selectedSport,
    required this.topSports,
  });

  @override
  State<_SportFilterSheet> createState() => _SportFilterSheetState();
}

class _SportFilterSheetState extends State<_SportFilterSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = _query.trim().toLowerCase();
    final filteredTopSports = widget.topSports.where((sport) {
      if (normalizedQuery.isEmpty) return true;
      return sport.name.toLowerCase().contains(normalizedQuery);
    }).toList();

    final filteredCategories = <RecordSportCategory>[];
    for (final category in RecordSportCatalog.categories) {
      final matches = category.sports.where((sport) {
        if (normalizedQuery.isEmpty) return true;
        return sport.name.toLowerCase().contains(normalizedQuery) ||
            category.title.toLowerCase().contains(normalizedQuery);
      }).toList();
      if (matches.isNotEmpty) {
        filteredCategories.add(
          RecordSportCategory(title: category.title, sports: matches),
        );
      }
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Material(
          color: Styles.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Radii.card),
            ),
            side: BorderSide(color: Styles.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Styles.borderStrong,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Filter by Sport',
                          style: TextStyle(
                            color: Styles.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close',
                        icon: const Icon(
                          Icons.close,
                          color: Styles.textSecondary,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Styles.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Search sport...',
                      hintStyle: const TextStyle(color: Styles.textMuted),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Styles.textSecondary,
                      ),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Styles.textSecondary,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                            ),
                      filled: true,
                      fillColor: Styles.fieldFill,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Radii.field),
                        borderSide: const BorderSide(color: Styles.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Radii.field),
                        borderSide: const BorderSide(color: Styles.borderGlow),
                      ),
                    ),
                    onChanged: (value) => setState(() => _query = value),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    children: [
                      if (filteredTopSports.isNotEmpty) ...[
                        _buildCategoryHeader('Your Top Sports'),
                        ...filteredTopSports.map(_buildSportTile),
                        const SizedBox(height: 12),
                      ],
                      if (filteredCategories.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 28),
                          child: Center(
                            child: Text(
                              'No matching sports found.',
                              style: TextStyle(color: Styles.textSecondary),
                            ),
                          ),
                        )
                      else
                        for (final category in filteredCategories) ...[
                          _buildCategoryHeader(category.title),
                          ...category.sports.map(_buildSportTile),
                          const SizedBox(height: 12),
                        ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          color: Styles.primaryLight,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSportTile(RecordSportItem sport) {
    final isSelected = sport.id == widget.selectedSport.id;
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.chip),
      ),
      tileColor: isSelected ? Styles.surfaceHighlight : Colors.transparent,
      leading: Icon(
        sport.icon,
        color: isSelected ? Styles.primaryLight : Styles.textSecondary,
        size: 20,
      ),
      title: Text(
        sport.name,
        style: TextStyle(
          color: isSelected ? Styles.textPrimary : Styles.textSecondary,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: Styles.primaryLight, size: 18)
          : null,
      onTap: () => Navigator.of(context).pop(sport),
    );
  }
}
