import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class AktivitasTab extends StatelessWidget {
  final int activityCount;
  final VoidCallback onAddFirstActivity;

  const AktivitasTab({
    super.key,
    required this.activityCount,
    required this.onAddFirstActivity,
  });

  @override
  Widget build(BuildContext context) {
    final int totalKm = activityCount * 3;
    final int totalMins = activityCount * 20;
    final int estCalories = activityCount * 215;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: Styles.cardDecoration(
              radius: Radii.card,
              highlighted: true,
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    gradient: Styles.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: Styles.glow(intensity: 0.28, blur: 12),
                  ),
                  child: const Icon(
                    Icons.add_task_rounded,
                    color: Styles.canvas,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Log a Training Session',
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          color: Styles.textPrimary,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Record a quick run to update your journal and unlock milestones.',
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.35,
                          color: Styles.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.primary,
                    foregroundColor: Styles.textPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.chip),
                    ),
                  ),
                  onPressed: onAddFirstActivity,
                  child: const Text(
                    '+ Log',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'RECENT TIMELINE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
              color: Styles.primaryLight,
            ),
          ),
          const SizedBox(height: 10),
          if (activityCount == 0)
            Container(
              width: double.infinity,
              decoration: Styles.cardDecoration(radius: Radii.card),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: const Column(
                children: [
                  Icon(
                    Icons.directions_run_rounded,
                    size: 38,
                    color: Styles.textSecondary,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No sessions logged yet',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: Styles.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tap "+ Log" above to start building your training streak.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Styles.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              decoration: Styles.cardDecoration(
                radius: Radii.card,
                withGlow: true,
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Styles.success.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.directions_run_rounded,
                          color: Styles.success,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Morning Tempo Run',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Styles.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$activityCount completed ${activityCount == 1 ? 'session' : 'sessions'}  •  Synced',
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: Styles.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.verified_rounded,
                        color: Styles.success,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Styles.canvas.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(Radii.field),
                      border: Border.all(color: Styles.border),
                    ),
                    child: Row(
                      children: [
                        _SessionStat(label: 'Distance', value: '$totalKm km'),
                        _SessionStat(label: 'Duration', value: '${totalMins}m'),
                        _SessionStat(
                          label: 'Est. Burn',
                          value: '$estCalories kcal',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SessionStat extends StatelessWidget {
  final String label;
  final String value;

  const _SessionStat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              color: Styles.textSecondary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: Styles.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}