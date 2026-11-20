import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
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
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Styles.inactive,
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
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Palette.fieldFill,
                          borderRadius: BorderRadius.circular(Radii.chip),
                          border: Border.all(color: Palette.cardBorder),
                        ),
                        child: Icon(
                          gear.category.icon,
                          color: Styles.accent,
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
                                fontWeight: FontWeight.bold,
                                color: Styles.tabActive,
                              ),
                            ),
                            Text(
                              gear.isRetired
                                ? '${gear.category.label} • Dipensiunkan'
                                : '${gear.category.label} • Aktif',
                              style: TextStyle(
                                fontSize: 12,
                                color: gear.isRetired
                                  ? Styles.tabInactive
                                  : Styles.active,
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
                  icon: const Icon(Icons.close, color: Styles.tabInactive),
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
                  backgroundColor: Styles.background,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    gear.isReplacementDue ? Colors.redAccent : Styles.accent,
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
                    ? Colors.redAccent
                    : Styles.tabInactive,
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (!gear.isRetired) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text(
                    'Catat Jarak Cepat:',
                    style: TextStyle(fontSize: 12, color: Styles.tabInactive),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Styles.accent,
                      side: const BorderSide(color: Styles.accent),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                    ),
                    onPressed: () {
                      ref
                        .read(athleteGearProvider.notifier)
                        .addDistance(gear.id, 5.0);
                    },
                    child: const Text('+5 km'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Styles.accent,
                      side: const BorderSide(color: Styles.accent),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                    ),
                    onPressed: () {
                      ref
                        .read(athleteGearProvider.notifier)
                        .addDistance(gear.id, 25.0);
                    },
                    child: const Text('+25 km'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.accent,
                  foregroundColor: Styles.tabActive,
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Styles.surface,
                      content: Text(
                        gear.isRetired
                          ? '${gear.displayName} berhasil diaktifkan kembali.'
                          : '${gear.displayName} dipindahkan ke daftar pensiun.',
                        style: const TextStyle(color: Styles.tabActive),
                      ),
                    ),
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
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Styles.tabActive,
                  side: const BorderSide(color: Palette.cardBorder),
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
              color: Styles.tabInactive,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Styles.tabActive,
            ),
          ),
        ],
      ),
    );
  }
}