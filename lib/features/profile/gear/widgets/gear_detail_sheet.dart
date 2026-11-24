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

    return Container(
      decoration: const BoxDecoration(
        color: Styles.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.card)),
        border: Border(
          top: BorderSide(color: Styles.borderStrong, width: 1.2),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
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
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: Styles.surfaceHighlight,
                          borderRadius: BorderRadius.circular(Radii.chip),
                          border: Border.all(
                            color: Styles.primary.withValues(alpha: 0.45),
                          ),
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
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Styles.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              gear.isRetired
                                ? '${gear.category.label} • Dipensiunkan'
                                : '${gear.category.label} • Aktif',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: gear.isRetired
                                  ? Styles.textSecondary
                                  : Styles.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Styles.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _DetailRow(
              label: gear.category.subTypeFieldLabel,
              value: gear.subType.isNotEmpty ? gear.subType : '-',
            ),
            _DetailRow(
              label: 'Merek',
              value: gear.brand.isNotEmpty ? gear.brand : '-',
            ),
            _DetailRow(
              label: 'Model',
              value: gear.model.isNotEmpty ? gear.model : '-',
            ),
            if (gear.category == GearCategory.bike && gear.weightKg != null)
              _DetailRow(
                label: 'Berat',
                value:
                  '${gear.weightKg!.toStringAsFixed(1).replaceAll('.', ',')} kg',
              ),
            if (gear.category == GearCategory.wearable &&
                gear.batteryHours != null)
              _DetailRow(
                label: 'Daya Tahan Baterai',
                value: '${gear.batteryHours} jam',
              ),
            _DetailRow(
              label: 'Jarak tempuh',
              value: gear.maxDistanceKm != null
                ? '${gear.formattedDistance} / ${gear.maxDistanceKm} km'
                : gear.formattedDistance,
            ),
            if (wearRatio != null) ...[
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: wearRatio,
                  minHeight: 8,
                  backgroundColor: Styles.canvas,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    gear.isReplacementDue ? Styles.danger : Styles.primary,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                gear.isReplacementDue
                  ? 'Target batas pemakaian tercapai — pertimbangkan ganti perlengkapan.'
                  : 'Terpakai ${(wearRatio * 100).round()}% dari batas target ${gear.maxDistanceKm} km',
                style: TextStyle(
                  fontSize: 12,
                  color: gear.isReplacementDue
                    ? Styles.danger
                    : Styles.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (!gear.isRetired) ...[
              const SizedBox(height: 4),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  const Text(
                    'Catat Jarak Cepat:',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Styles.textSecondary,
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Styles.surfaceElevated,
                      foregroundColor: Styles.primaryLight,
                      side: const BorderSide(color: Styles.primary),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                    ),
                    onPressed: () {
                      ref
                        .read(athleteGearProvider.notifier)
                        .addDistance(gear.id, 5.0);
                    },
                    child: const Text(
                      '+5 km',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Styles.surfaceElevated,
                      foregroundColor: Styles.primaryLight,
                      side: const BorderSide(color: Styles.primary),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                    ),
                    onPressed: () {
                      ref
                        .read(athleteGearProvider.notifier)
                        .addDistance(gear.id, 25.0);
                    },
                    child: const Text(
                      '+25 km',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],
            if (gear.notes.trim().isNotEmpty)
              _DetailRow(label: 'Catatan', value: gear.notes.trim()),
            _DetailRow(
              label: 'Olahraga Default',
              value: gear.defaultSports.isEmpty
                ? 'Tidak ada'
                : gear.defaultSports.join(', '),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Styles.primaryDark, Styles.primary],
                  ),
                  borderRadius: BorderRadius.circular(Radii.button),
                  boxShadow: Styles.glow(intensity: 0.35, blur: 18),
                ),
                child: ElevatedButton(
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
                        ? '${gear.displayName} berhasil diaktifkan kembali.'
                        : '${gear.displayName} dipindahkan ke daftar pensiun.',
                    );
                  },
                  child: Text(
                    gear.isRetired
                      ? 'Aktifkan Kembali ${gear.category.label}'
                      : 'Pensiunkan ${gear.category.label}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
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
                child: Text(
                  'Edit ${gear.category.label}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Styles.textSecondary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: Styles.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}