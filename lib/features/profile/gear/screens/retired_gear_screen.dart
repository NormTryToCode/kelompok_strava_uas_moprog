import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

import '../models/athlete_gear.dart';
import '../providers/athlete_gear_provider.dart';
import '../widgets/gear_detail_sheet.dart';
import 'gear_form_screen.dart';

class RetiredGearScreen extends ConsumerWidget {
  final GearCategory category;

  const RetiredGearScreen({super.key, required this.category});

  void _openDetailSheet(BuildContext context, AthleteGear gear) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GearDetailSheet(
        gearId: gear.id,
        onEdit: (selectedGear) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => GearFormScreen(existingGear: selectedGear),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allGear = ref.watch(athleteGearProvider);
    final retiredItems = allGear
        .where((item) => item.category == category && item.isRetired)
        .toList();

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppBar(
        backgroundColor: Styles.canvas,
        foregroundColor: Styles.primaryLight,
        title: Text(
          category.retiredLabel,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Styles.primaryLight,
          ),
        ),
      ),
      body: SafeArea(
        child: retiredItems.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        category.icon,
                        size: 48,
                        color: Styles.surfaceHighlight,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Tidak ada perlengkapan yang dipensiunkan pada kategori ini.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Styles.surfaceHighlight,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: retiredItems.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final gear = retiredItems[index];
                  return Material(
                    color: Styles.surface,
                    borderRadius: BorderRadius.circular(Radii.chip),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(Radii.chip),
                      onTap: () => _openDetailSheet(context, gear),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Radii.chip),
                          border: Border.all(color: Styles.cardBorder),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              category.icon,
                              color: Styles.surfaceHighlight,
                              size: 24,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    gear.displayName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Styles.primaryLight,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    gear.brandModelSubtitle,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Styles.surfaceHighlight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              gear.formattedDistance,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Styles.surfaceHighlight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

