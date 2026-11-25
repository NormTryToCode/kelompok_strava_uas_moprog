import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../../shared/utils/profile_snackbar_helper.dart';
import '../models/athlete_gear.dart';
import '../providers/athlete_gear_provider.dart';

class GearDetailSheet extends ConsumerWidget {
  final String gearId;
  final ValueChanged<AthleteGear> onEdit;

  const GearDetailSheet({
    super.key,
    required this.gearId,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allGear = ref.watch(athleteGearProvider);
    final matches = allGear.where((item) => item.id == gearId);
    if (matches.isEmpty) {
      return const SizedBox.shrink();
    }
    final AthleteGear gear = matches.first;
    final double? wearRatio = gear.wearProgressRatio;
    final List<String> sports = gear.displayDefaultSports;

    final Color healthColor = gear.isReplacementDue
      ? Styles.danger
      : gear.isHighWear
        ? Styles.warning
        : Styles.primaryLight;

    return Container(
      decoration: const BoxDecoration(
        color: Styles.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.card)),
        border: Border(
          top: BorderSide(color: Styles.borderStrong, width: 1.3),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 26),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
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
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Styles.surfaceHighlight,
                          borderRadius: BorderRadius.circular(Radii.field),
                          border: Border.all(
                            color: Styles.primary.withValues(alpha: 0.55),
                          ),
                          boxShadow: Styles.glow(intensity: 0.2, blur: 12),
                        ),
                        child: Icon(
                          gear.category.icon,
                          color: Styles.primaryLight,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gear.displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Styles.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: gear.isRetired
                                      ? Styles.textSecondary
                                      : gear.isReplacementDue
                                        ? Styles.danger
                                        : Styles.success,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    '${gear.category.label}  •  ${gear.wearStatusLabel}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: gear.isRetired
                                        ? Styles.textSecondary
                                        : gear.isReplacementDue
                                          ? Styles.danger
                                          : Styles.success,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Styles.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: Styles.cardDecoration(
                radius: Radii.field,
                highlighted: true,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'MILEAGE & WEAR TELEMETRY',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.9,
                          color: Styles.primaryLight,
                        ),
                      ),
                      Text(
                        gear.maxDistanceKm != null
                          ? '${gear.formattedDistance} / ${gear.maxDistanceKm} km'
                          : gear.formattedDistance,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Styles.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  if (wearRatio != null) ...[
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final double fillW =
                          (constraints.maxWidth * wearRatio).clamp(
                            wearRatio > 0 ? 12.0 : 0.0,
                            constraints.maxWidth,
                        );
                        return Container(
                          width: constraints.maxWidth,
                          height: 9,
                          decoration: BoxDecoration(
                            color: Styles.canvas,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: fillW,
                            height: 9,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gear.isReplacementDue
                                  ? const [Styles.danger, Color(0xFFFF9EB0)]
                                  : gear.isHighWear
                                    ? const [
                                        Styles.warning,
                                        Color(0xFFFDE68A),
                                      ]
                                    : const [
                                        Styles.primary,
                                        Styles.primaryLight,
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: Styles.glow(
                                color: healthColor,
                                intensity: 0.4,
                                blur: 10,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      gear.isReplacementDue
                        ? 'Recommended lifespan reached — consider replacing this equipment.'
                        : '${(wearRatio * 100).round()}% used • ${gear.remainingDistanceKm!.round()} km remaining before threshold.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: gear.isReplacementDue
                          ? Styles.danger
                          : Styles.textSecondary,
                      ),
                    ),
                  ],
                  if (!gear.isRetired) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        const Text(
                          'Quick Log:',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Styles.textSecondary,
                          ),
                        ),
                        _QuickKmChip(
                          label: '+5 km',
                          onTap: () => ref
                            .read(athleteGearProvider.notifier)
                            .addDistance(gear.id, 5.0),
                        ),
                        _QuickKmChip(
                          label: '+10 km',
                          onTap: () => ref
                            .read(athleteGearProvider.notifier)
                            .addDistance(gear.id, 10.0),
                        ),
                        _QuickKmChip(
                          label: '+25 km',
                          onTap: () => ref
                            .read(athleteGearProvider.notifier)
                            .addDistance(gear.id, 25.0),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _SpecBox(
                    label: gear.category.subTypeFieldLabel,
                    value: gear.displaySubType.isNotEmpty
                      ? gear.displaySubType
                      : '-',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SpecBox(
                    label: 'Brand',
                    value: gear.brand.isNotEmpty ? gear.brand : '-',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _SpecBox(
                    label: 'Model',
                    value: gear.model.isNotEmpty ? gear.model : '-',
                  ),
                ),
                if (gear.category == GearCategory.bike &&
                    gear.weightKg != null) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SpecBox(
                      label: 'Frame Weight',
                      value: '${gear.weightKg!.toStringAsFixed(1)} kg',
                    ),
                  ),
                ] else if (gear.category == GearCategory.wearable &&
                    gear.batteryHours != null) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SpecBox(
                      label: 'Battery Life',
                      value: '${gear.batteryHours} hours',
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'ASSIGNED SPORTS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.9,
                color: Styles.primaryLight,
              ),
            ),
            const SizedBox(height: 8),
            if (sports.isEmpty)
              const Text(
                'No default sports assigned',
                style: TextStyle(fontSize: 13.5, color: Styles.textSecondary),
              )
            else
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: sports
                  .map(
                    (s) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Styles.surfaceElevated,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Styles.borderStrong),
                      ),
                      child: Text(
                        s,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Styles.textPrimary,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              ),
            if (gear.notes.trim().isNotEmpty) ...[
              const SizedBox(height: 14),
              _SpecBox(label: 'Maintenance Notes', value: gear.notes.trim()),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Styles.primaryDark, Styles.primary],
                  ),
                  borderRadius: BorderRadius.circular(Radii.button),
                  boxShadow: Styles.glow(intensity: 0.32, blur: 16),
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Styles.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.button),
                    ),
                  ),
                  onPressed: () async {
                    await ref
                      .read(athleteGearProvider.notifier)
                      .toggleRetireGear(gear.id);
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                    ProfileSnackbarHelper.showSuccess(
                      context,
                      gear.isRetired
                        ? '"${gear.displayName}" restored to Active Gear Locker.'
                        : '"${gear.displayName}" moved to Retired Archive.',
                    );
                  },
                  icon: Icon(
                    gear.isRetired
                      ? Icons.restore_rounded
                      : Icons.inventory_2_outlined,
                    size: 18,
                  ),
                  label: Text(
                    gear.isRetired
                      ? 'Restore to Active Locker'
                      : 'Archive ${gear.category.label}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Styles.surfaceElevated,
                  foregroundColor: Styles.textPrimary,
                  side: const BorderSide(color: Styles.borderStrong),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.button),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  onEdit(gear);
                },
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text(
                  'Edit Specifications',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
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

class _QuickKmChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickKmChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Styles.canvas.withValues(alpha: 0.7),
        foregroundColor: Styles.primaryLight,
        side: const BorderSide(color: Styles.primary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onTap,
      child: Text(
        label,
        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _SpecBox extends StatelessWidget {
  final String label;
  final String value;

  const _SpecBox({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Styles.canvas.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(Radii.field),
        border: Border.all(color: Styles.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Styles.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: Styles.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}