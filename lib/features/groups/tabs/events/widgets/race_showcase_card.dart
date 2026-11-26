import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/int_extensions.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/race_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/services/location_photo_service.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/utils/event_date_format.dart';

class RaceShowcaseCard extends ConsumerWidget {
  final Race race;
  final VoidCallback onTap;
  final double? width;

  const RaceShowcaseCard({
    super.key,
    required this.race,
    required this.onTap,
    this.width,
  });

  String _priceLabel() {
    if (race.minPriceIdr <= 0) return 'Free';
    return 'Rp ${(race.minPriceIdr ~/ 1000).withThousands}K';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoAsync = ref.watch(
      locationPhotoProvider(
        LocationPhotoQuery(
          latitude: race.latitude,
          longitude: race.longitude,
          placeName: race.landmarkQuery ?? race.city,
          detail: race.region,
        ),
      ),
    );
    final photoUrl = photoAsync.valueOrNull;

    return Container(
      width: width,
      decoration: Styles.cardDecoration(
        radius: Radii.card,
        withGlow: race.isRegistered,
        borderColor: race.isRegistered
            ? Styles.borderGlow.withValues(alpha: 0.6)
            : Styles.border,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 152,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: Styles.coverFor(race.id),
                      ),
                    ),
                    if (photoUrl != null)
                      Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Styles.canvas.withValues(alpha: 0.35),
                            Colors.transparent,
                            Styles.surface.withValues(alpha: 0.94),
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 12,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Styles.canvas.withValues(alpha: 0.78),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Styles.borderStrong),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  race.sport.icon,
                                  size: 13.5,
                                  color: Styles.primaryLight,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  race.sport.name,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: Styles.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: race.isRegistered
                                  ? Styles.primary
                                  : Styles.surfaceHighlight.withValues(
                                      alpha: 0.92,
                                    ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: race.isRegistered
                                    ? Styles.primaryLight
                                    : Styles.borderStrong,
                              ),
                            ),
                            child: Text(
                              race.isRegistered
                                  ? 'Registered'
                                  : formatDate(race.startDate),
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Styles.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 14,
                      right: 14,
                      bottom: 10,
                      child: Text(
                        race.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Styles.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14.5,
                          color: Styles.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            race.locationLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Styles.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: Styles.fieldFill,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Styles.border),
                      ),
                      child: Row(
                        children: [
                          _MiniMetric(
                            label: 'DISTANCE',
                            value: race.distanceRangeLabel,
                          ),
                          const _MetricSep(),
                          _MiniMetric(
                            label: 'ELEVATION',
                            value: '+${race.elevationGainMeters}m',
                          ),
                          const _MetricSep(),
                          _MiniMetric(
                            label: 'ENTRY',
                            value: _priceLabel(),
                            highlight: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.groups_outlined,
                          size: 15,
                          color: Styles.primaryLight,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${race.registeredCount.withThousands} athletes racing',
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Styles.textSecondary,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: Styles.textMuted,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _MiniMetric({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: Styles.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: highlight ? Styles.primaryLight : Styles.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricSep extends StatelessWidget {
  const _MetricSep();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Styles.divider,
    );
  }
} 