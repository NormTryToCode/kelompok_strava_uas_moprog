import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/home/daily_challenge_page.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class DailyChallengeWidget extends StatefulWidget {
  const DailyChallengeWidget({super.key});

  @override
  State<DailyChallengeWidget> createState() => _DailyChallengeWidgetState();
}

class _DailyChallengeWidgetState extends State<DailyChallengeWidget> {
  static const double _targetKm = 2.5;
  double _currentKm = 1.0;

  Future<void> _openChallengePage() async {
    final updatedKm = await Navigator.of(context).push<double>(
      MaterialPageRoute(
        builder: (_) => DailyChallengePage(
          initialDistanceKm: _currentKm,
          targetDistanceKm: _targetKm,
        ),
      ),
    );
    if (updatedKm != null && mounted) {
      setState(() {
        _currentKm = updatedKm.clamp(0.0, _targetKm);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentKm / _targetKm).clamp(0.0, 1.0);
    final isCompleted = _currentKm >= _targetKm;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: Styles.cardDecoration(withGlow: true),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: isCompleted
                ? Styles.success.withValues(alpha: 0.18)
                : Styles.primaryDark,
            child: PhosphorIcon(
              isCompleted
                  ? PhosphorIconsRegular.trophy
                  : PhosphorIconsRegular.sneakerMove,
              size: 28,
              color: isCompleted ? Styles.success : Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'DAILY CHALLENGE',
                  style: TextStyle(
                    color: isCompleted ? Styles.success : Styles.primaryLight,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.9,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Run 2.5 km',
                  style: TextStyle(
                    color: Styles.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_currentKm.toStringAsFixed(1)} / ${_targetKm.toStringAsFixed(1)} km • Keep your streak alive',
                  style: const TextStyle(
                    color: Styles.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: Styles.surfaceHighlight,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? Styles.success : Styles.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _openChallengePage,
            style: ElevatedButton.styleFrom(
              backgroundColor: isCompleted ? Styles.success : Styles.primary,
              foregroundColor: Styles.textPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            ),
            child: Text(
              isCompleted ? 'Done' : 'Start',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
