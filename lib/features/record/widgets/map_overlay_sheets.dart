import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

/// Displays map attribution & data sources used on RecordTrackPage.
Future<void> showMapDataSourcesSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Styles.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.card)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              const SizedBox(height: 12),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Map data sources',
                      style: TextStyle(
                        color: Styles.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Styles.textSecondary),
                    onPressed: () => Navigator.of(sheetContext).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Base map tiles provided by OpenStreetMap contributors (https://tile.openstreetmap.org).',
                style: TextStyle(
                  color: Styles.textSecondary,
                  fontSize: 13.5,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Displays map layer framework options (Map Types, Heatmaps, Layers).
Future<void> showMapLayersSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Styles.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.card)),
    ),
    builder: (_) => const _MapLayersSheet(),
  );
}

class _MapLayersSheet extends StatefulWidget {
  const _MapLayersSheet();

  @override
  State<_MapLayersSheet> createState() => _MapLayersSheetState();
}

class _MapLayersSheetState extends State<_MapLayersSheet> {
  String _selectedMapType = 'Standard';
  bool _globalRunHeatmap = false;
  bool _pointsOfInterest = false;
  bool _bikeLanes = false;

  static const _mapTypes = ['Standard', 'Satellite', 'Hybrid'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Map Layers',
                    style: TextStyle(
                      color: Styles.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Styles.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Text(
              'Map layer options are framework previews (currently using OpenStreetMap Standard).',
              style: TextStyle(color: Styles.textSecondary, fontSize: 12.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Map Types',
              style: TextStyle(
                color: Styles.primaryLight,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _mapTypes.map((type) {
                final isSelected = _selectedMapType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  selectedColor: Styles.surfaceHighlight,
                  backgroundColor: Styles.fieldFill,
                  side: BorderSide(
                    color: isSelected ? Styles.borderGlow : Styles.border,
                  ),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Styles.textPrimary
                        : Styles.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (_) => setState(() => _selectedMapType = type),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Heatmaps',
              style: TextStyle(
                color: Styles.primaryLight,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Global Run',
                style: TextStyle(color: Styles.textPrimary, fontSize: 14),
              ),
              value: _globalRunHeatmap,
              activeThumbColor: Styles.primaryLight,
              onChanged: (value) => setState(() => _globalRunHeatmap = value),
            ),
            const Divider(color: Styles.divider),
            const Text(
              'Layers',
              style: TextStyle(
                color: Styles.primaryLight,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Points of Interest',
                style: TextStyle(color: Styles.textPrimary, fontSize: 14),
              ),
              value: _pointsOfInterest,
              activeThumbColor: Styles.primaryLight,
              onChanged: (value) => setState(() => _pointsOfInterest = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Bike Lanes',
                style: TextStyle(color: Styles.textPrimary, fontSize: 14),
              ),
              value: _bikeLanes,
              activeThumbColor: Styles.primaryLight,
              onChanged: (value) => setState(() => _bikeLanes = value),
            ),
          ],
        ),
      ),
    );
  }
}
