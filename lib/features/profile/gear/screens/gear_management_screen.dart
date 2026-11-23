import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

import '../models/athlete_gear.dart';
import '../providers/athlete_gear_provider.dart';
import '../widgets/gear_detail_sheet.dart';
import 'gear_form_screen.dart';
import 'retired_gear_screen.dart';

class GearManagementView extends ConsumerWidget {
  final VoidCallback onBack;

  const GearManagementView({super.key, required this.onBack});

  void _openAddGearScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const GearFormScreen()));
  }

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

  void _openRetiredScreen(BuildContext context, GearCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RetiredGearScreen(category: category)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<AthleteGear> allGear = ref.watch(athleteGearProvider);
    final int activeTotal = allGear.where((g) => !g.isRetired).length;
    final double totalTrackedKm = allGear.fold<double>(
      0.0,
      (sum, item) => sum + item.currentDistanceKm,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Styles.primaryLight,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Perlengkapan Anda',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Styles.primaryLight,
                    ),
                  ),
                ],
              ),
              IconButton(
                tooltip: 'Tambahkan Perlengkapan',
                onPressed: () => _openAddGearScreen(context),
                icon: const Icon(
                  Icons.add,
                  size: 28,
                  color: Styles.primaryLight,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Styles.surfaceHighlight),
        Expanded(
          child: allGear.isEmpty
              ? _EmptyGearState(onAddGear: () => _openAddGearScreen(context))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Styles.surface,
                        borderRadius: BorderRadius.circular(Radii.field),
                        border: Border.all(color: Styles.cardBorder),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Perlengkapan Aktif',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Styles.surfaceHighlight,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$activeTotal unit',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Styles.primaryLight,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Total Jarak Terlacak',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Styles.surfaceHighlight,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${totalTrackedKm.toStringAsFixed(0)} km',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Styles.accent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    ...GearCategory.values.map((category) {
                      final activeInCat = allGear
                          .where((g) => g.category == category && !g.isRetired)
                          .toList();
                      final retiredInCat = allGear
                          .where((g) => g.category == category && g.isRetired)
                          .toList();

                      if (activeInCat.isEmpty && retiredInCat.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      category.icon,
                                      size: 16,
                                      color: Styles.accent,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      category.sectionHeader,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.8,
                                        color: Styles.surfaceHighlight,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${activeInCat.length}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Styles.surfaceHighlight,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...activeInCat.map(
                              (gear) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _GearListItemCard(
                                  gear: gear,
                                  onTap: () => _openDetailSheet(context, gear),
                                ),
                              ),
                            ),
                            if (retiredInCat.isNotEmpty)
                              Material(
                                color: Styles.fieldFill,
                                borderRadius: BorderRadius.circular(Radii.chip),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(
                                    Radii.chip,
                                  ),
                                  onTap: () =>
                                      _openRetiredScreen(context, category),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        Radii.chip,
                                      ),
                                      border: Border.all(
                                        color: Styles.cardBorder,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          category.retiredLabel,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Styles.surfaceHighlight,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${retiredInCat.length}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Styles.surfaceHighlight,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(
                                              Icons.chevron_right,
                                              color: Styles.surfaceHighlight,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Styles.accent,
                          side: const BorderSide(color: Styles.accent),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Radii.button),
                          ),
                        ),
                        onPressed: () => _openAddGearScreen(context),
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'Tambahkan Perlengkapan',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _EmptyGearState extends StatelessWidget {
  final VoidCallback onAddGear;

  const _EmptyGearState({required this.onAddGear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Styles.surface,
                shape: BoxShape.circle,
                border: Border.all(color: Styles.cardBorder),
              ),
              child: const Icon(
                Icons.pedal_bike,
                size: 44,
                color: Styles.accent,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tambahkan sepatu, sepeda, atau perlengkapan olahraga untuk melacak jarak dan penggunaan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: Styles.surfaceHighlight,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.accent,
                  foregroundColor: Styles.primaryLight,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: const StadiumBorder(),
                ),
                onPressed: onAddGear,
                child: const Text(
                  'Tambahkan Perlengkapan',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GearListItemCard extends StatelessWidget {
  final AthleteGear gear;
  final VoidCallback onTap;

  const _GearListItemCard({required this.gear, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double? wearRatio = gear.wearProgressRatio;

    return Material(
      color: Styles.surface,
      borderRadius: BorderRadius.circular(Radii.chip),
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.chip),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radii.chip),
            border: Border.all(color: Styles.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Styles.primaryLight,
                    ),
                  ),
                ],
              ),
              if (wearRatio != null) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: wearRatio,
                    minHeight: 5,
                    backgroundColor: Styles.canvas,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      gear.isReplacementDue ? Colors.redAccent : Styles.accent,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Target maksimal: ${gear.maxDistanceKm} km',
                  style: TextStyle(
                    fontSize: 11,
                    color: gear.isReplacementDue
                        ? Colors.redAccent
                        : Styles.surfaceHighlight,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

