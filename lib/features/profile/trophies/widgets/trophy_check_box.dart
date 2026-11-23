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
      child: Container(
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.all(4),
        child: Icon(
          isClaimed
            ? Icons.check_box_outlined
            : Icons.check_box_outline_blank,
          color: isClaimed ? Styles.accent : Styles.tabInactive,
        ),
      ),
    );
  }
}