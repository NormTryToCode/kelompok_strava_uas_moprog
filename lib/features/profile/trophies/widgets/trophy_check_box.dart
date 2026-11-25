import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../models/trophy_badge.dart';
import '../providers/trophy_provider.dart';

class TrophyCheckBox extends ConsumerWidget {
  final TrophyBadge badge;

  const TrophyCheckBox({
    super.key,
    required this.badge,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isClaimed = ref.watch(claimedTrophiesProvider).contains(badge.id);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ref.read(claimedTrophiesProvider.notifier).toggleClaim(badge.id);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isClaimed
            ? Styles.success.withValues(alpha: 0.18)
            : Styles.surfaceElevated,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isClaimed ? Styles.success : Styles.borderStrong,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isClaimed
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
              size: 18,
              color: isClaimed ? Styles.success : Styles.textSecondary,
            ),
            const SizedBox(width: 5),
            Text(
              isClaimed ? 'Claimed' : 'Manual',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isClaimed ? Styles.success : Styles.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}