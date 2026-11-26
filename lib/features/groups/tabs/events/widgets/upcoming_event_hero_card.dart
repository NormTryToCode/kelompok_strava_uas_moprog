import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/services/location_photo_service.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/utils/event_date_format.dart';

class UpcomingEventHeroCard extends ConsumerWidget {
  final Event event;
  final VoidCallback onTap;
  final double? width;

  const UpcomingEventHeroCard({
    super.key,
    required this.event,
    required this.onTap,
    this.width,
  });

  String _formatSchedule() {
    final d = event.startsAt;
    return '${weekdayShort(d.weekday)}, ${d.day} ${monthShort(d.month)} \u00b7 ${formatClock24(d)}';
  }

  String _countdownLabel() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(
      event.startsAt.year,
      event.startsAt.month,
      event.startsAt.day,
    );
    final diff = target.difference(today).inDays;
    if (diff <= 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff < 30) return 'In $diff days';
    final months = (diff / 30).round();
    return months == 1 ? 'In 1 mo' : 'In $months mos';
  }

  String _formatDistance() {
    final d = event.distance;
    if (d == null) return '';
    final text = d == d.roundToDouble() ? d.toStringAsFixed(0) : d.toString();
    return '$text ${event.distanceUnit.label}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = event.isVirtual
        ? null
        : LocationPhotoQuery(
            latitude: event.location?.latitude,
            longitude: event.location?.longitude,
            placeName: event.location?.name ?? event.placeLabel,
            detail: event.location?.detail,
          );

    final photoAsync =
        query == null ? null : ref.watch(locationPhotoProvider(query));
    final photoUrl = photoAsync?.valueOrNull;
    final distanceText = _formatDistance();

    return Container(
      width: width,
      decoration: Styles.cardDecoration(
        radius: Radii.card,
        highlighted: false,
        withGlow: true,
        borderColor: Styles.borderGlow.withValues(alpha: 0.42),
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
                height: 146,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _AreaBannerBackground(
                      event: event,
                      photoUrl: photoUrl,
                      isLoading: photoAsync?.isLoading ?? false,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Styles.canvas.withValues(alpha: 0.42),
                            Styles.canvas.withValues(alpha: 0.14),
                            Styles.surface.withValues(alpha: 0.92),
                            Styles.surface,
                          ],
                          stops: const [0.0, 0.35, 0.85, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 12,
                      child: Row(
                        children: [
                          _FrostedPill(
                            icon: event.sport?.icon ?? event.kind.icon,
                            label: (event.sport?.name ?? event.kind.name),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              gradient: Styles.linearGradient(
                                colors: const [
                                  Styles.primary,
                                  Styles.primaryLight,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: Styles.glow(
                                intensity: 0.35,
                                blur: 12,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_rounded,
                                  size: 13.5,
                                  color: Styles.textPrimary,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Going',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                    color: Styles.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 14,
                      right: 14,
                      bottom: 10,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: Styles.primaryLight,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _formatSchedule(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: Styles.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Styles.surfaceHighlight
                                  .withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Styles.borderStrong),
                            ),
                            child: Text(
                              _countdownLabel(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Styles.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17.5,
                        fontWeight: FontWeight.w800,
                        color: Styles.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          event.isVirtual
                              ? Icons.public
                              : Icons.location_on_outlined,
                          size: 14.5,
                          color: Styles.textMuted,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            distanceText.isEmpty
                                ? event.placeLabel
                                : '${event.placeLabel} \u00b7 $distanceText',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Styles.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: Styles.divider),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: Styles.coverFor(event.clubId),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            event.clubName.isEmpty
                                ? '?'
                                : event.clubName[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Styles.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event.clubName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Styles.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.people_outline,
                          size: 14,
                          color: Styles.primaryLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.attendeeLabel,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Styles.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 6),
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

class _AreaBannerBackground extends StatelessWidget {
  final Event event;
  final String? photoUrl;
  final bool isLoading;

  const _AreaBannerBackground({
    required this.event,
    required this.photoUrl,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = DecoratedBox(
      decoration: BoxDecoration(gradient: Styles.coverFor(event.clubId)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: Styles.radialGlow(
                color: Styles.primaryLight,
                intensity: 0.28,
                center: const Alignment(0.65, -0.3),
              ),
            ),
          ),
          Positioned(
            right: -12,
            bottom: -14,
            child: Icon(
              event.sport?.icon ?? event.kind.icon,
              size: 108,
              color: Styles.textPrimary.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );

    if (photoUrl == null) {
      return fallback;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        fallback,
        Image.network(
          photoUrl!,
          fit: BoxFit.cover,
          frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOut,
              child: child,
            );
          },
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _FrostedPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FrostedPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Styles.canvas.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Styles.borderStrong.withValues(alpha: 0.85)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.5, color: Styles.primaryLight),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: Styles.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}