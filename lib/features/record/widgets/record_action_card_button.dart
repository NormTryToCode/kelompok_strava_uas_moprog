import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';

/// Neon-purple sport card with quick-start CTA used on the Record screen.
class RecordActionCardButton extends StatelessWidget {
  final String action;
  final String? subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onStart;

  const RecordActionCardButton({
    super.key,
    required this.action,
    this.subtitle,
    this.onTap,
    this.onStart,
  });

  String get _sportId => switch (action) {
    'Walk' => 'walking',
    'Run' => 'running',
    'Ride' => 'cycling',
    _ => 'run-walk-hike',
  };

  String get _defaultSubtitle => switch (action) {
    'Walk' => 'Outdoor GPS Walk',
    'Run' => 'Outdoor GPS Run',
    'Ride' => 'Outdoor GPS Ride',
    _ => 'Outdoor GPS Activity',
  };

  @override
  Widget build(BuildContext context) {
    final sport = ClubSport.byId(_sportId);
    final effectiveSubtitle = subtitle ?? _defaultSubtitle;

    return Container(
      width: double.infinity,
      decoration: Styles.cardDecoration(radius: Radii.card, withGlow: true),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.card),
          onTap: onTap ?? onStart,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Styles.surfaceHighlight,
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: Styles.borderGlow.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Icon(
                        sport.icon,
                        color: Styles.primaryLight,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            action,
                            style: const TextStyle(
                              color: Styles.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            effectiveSubtitle,
                            style: const TextStyle(
                              color: Styles.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Styles.textMuted,
                      size: 22,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: Styles.buttonDecoration(
                    radius: Radii.button,
                    withGlow: true,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(Radii.button),
                      onTap: onStart ?? onTap,
                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_arrow_rounded,
                              color: Styles.textPrimary,
                              size: 20,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Start',
                              style: TextStyle(
                                color: Styles.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
