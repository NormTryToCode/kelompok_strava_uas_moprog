import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/int_extensions.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../../shared/utils/profile_page_route.dart';
import '../models/athlete_gear.dart';
import '../providers/athlete_gear_provider.dart';
import '../widgets/gear_detail_sheet.dart';
import 'gear_form_screen.dart';

class RetiredGearScreen extends ConsumerWidget {
  final GearCategory category;

  const RetiredGearScreen({
    super.key,
    required this.category,
  });

  void _openDetailSheet(BuildContext context, AthleteGear gear) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Theme(
        data: buildProfileDarkTheme(),
        child: GearDetailSheet(
          gearId: gear.id,
          onEdit: (selectedGear) {
            Navigator.of(context).push(
              buildProfileRoute(GearFormScreen(existingGear: selectedGear)),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allGear = ref.watch(athleteGearProvider);
    final retiredItems = allGear
      .where((item) => item.category == category && item.isRetired)
      .toList();
    final double archivedMileage = retiredItems.fold<double>(
      0.0,
      (sum, item) => sum + item.currentDistanceKm,
    );

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppBar(
        backgroundColor: Styles.canvas,
        foregroundColor: Styles.textPrimary,
        surfaceTintColor: Colors.transparent,
        title: Text(
          '${category.retiredLabel} Archive',
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Styles.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: retiredItems.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Styles.surfaceElevated,
                        shape: BoxShape.circle,
                        border: Border.all(color: Styles.borderStrong),
                      ),
                      child: Icon(
                        category.icon,
                        size: 40,
                        color: Styles.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Archive is Empty',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Styles.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'No retired ${category.pluralLabel.toLowerCase()} are stored in this archive.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Styles.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: Styles.cardDecoration(
                    radius: Radii.card,
                    highlighted: true,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Archived Units',
                            style: TextStyle(
                              fontSize: 12,
                              color: Styles.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${retiredItems.length} ${retiredItems.length == 1 ? 'item' : 'items'}',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: Styles.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Lifetime Distance',
                            style: TextStyle(
                              fontSize: 12,
                              color: Styles.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${archivedMileage.round().withThousands} km',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: Styles.primaryLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...retiredItems.map(
                  (gear) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: Styles.surface,
                      borderRadius: BorderRadius.circular(Radii.card),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(Radii.card),
                        onTap: () => _openDetailSheet(context, gear),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Radii.card),
                            border: Border.all(color: Styles.borderStrong),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Styles.surfaceElevated,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Styles.border),
                                ),
                                child: Icon(
                                  category.icon,
                                  color: Styles.textSecondary,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      gear.displayName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Styles.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      gear.brandModelSubtitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        color: Styles.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    gear.formattedDistance,
                                    style: const TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w800,
                                      color: Styles.primaryLight,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'ARCHIVED',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                      color: Styles.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}