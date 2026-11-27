import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/int_extensions.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/challenge_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/challenge_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/challenges/widgets/challenge_badge_emblem.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/utils/event_date_format.dart';
import 'package:share_plus/share_plus.dart';

class ChallengeDetailPage extends ConsumerWidget {
  final Challenge initialChallenge;

  const ChallengeDetailPage({super.key, required this.initialChallenge});

  static Future<void> open(BuildContext context, Challenge challenge) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ChallengeDetailPage(initialChallenge: challenge),
      ),
    );
  }

  void _openShareSheet(BuildContext context, Challenge challenge) {
    final shareText =
        'Join "${challenge.title}" (${formatChallengeTarget(challenge)}) hosted by ${challenge.organizingClubName}!';

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Styles.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Styles.borderStrong,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Send to',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Styles.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _ShareOption(
                      icon: Icons.copy_rounded,
                      label: 'Copy Link',
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: shareText));
                        Navigator.of(sheetCtx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Challenge link copied to clipboard'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                    _ShareOption(
                      icon: Icons.share_outlined,
                      label: 'Share To',
                      onTap: () {
                        Navigator.of(sheetCtx).pop();
                        SharePlus.instance.share(
                          ShareParams(text: shareText, subject: challenge.title),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(challengesProvider).valueOrNull ?? const <Challenge>[];
    final challenge = all.firstWhere(
      (c) => c.id == initialChallenge.id,
      orElse: () => initialChallenge,
    );
    final sports = challenge.qualifyingSports;
    final primarySport = sports.isNotEmpty ? sports.first : ClubSport.allSports;
    final sportsText = sports.map((s) => s.name).join(', ');

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppBar(
        backgroundColor: Styles.canvas,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Styles.textPrimary,
        title: const Text(
          'Challenge',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _openShareSheet(context, challenge),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: Styles.cardDecoration(
                    radius: Radii.card,
                    highlighted: true,
                    withGlow: true,
                  ),
                  child: Column(
                    children: [
                      ChallengeBadgeEmblem(
                        code: challenge.reward.badgeCode,
                        seedId: challenge.id,
                        sportIcon: primarySport.icon,
                        size: 78,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        challenge.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Styles.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        challenge.summary,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.4,
                          color: Styles.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          _DetailPill(
                            label: formatChallengeTarget(challenge),
                            accent: true,
                          ),
                          _DetailPill(label: primarySport.name),
                          _DetailPill(
                            label:
                                '${challenge.participantCount.withThousands} joined',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Organizing Club',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Styles.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: Styles.cardDecoration(radius: Radii.card),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: Styles.coverFor(challenge.organizingClubId),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          challenge.organizingClubName.isEmpty
                              ? '?'
                              : challenge.organizingClubName[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Styles.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              challenge.organizingClubName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Styles.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${challenge.organizingClubMembers.withThousands} Athletes',
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: Styles.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Challenge Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Styles.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: Styles.cardDecoration(radius: Radii.card),
                  child: Column(
                    children: [
                      _DetailInfoRow(
                        icon: Icons.calendar_today_outlined,
                        title:
                            '${formatDate(challenge.startDate)} to ${formatDate(challenge.endDate)}',
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1, color: Styles.divider),
                      ),
                      _DetailInfoRow(
                        icon: primarySport.icon,
                        title: challenge.summary,
                        subtitle: 'Qualifying Activities: $sportsText',
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1, color: Styles.divider),
                      ),
                      _DetailInfoRow(
                        icon: Icons.emoji_events_outlined,
                        title: challenge.reward.badgeTitle,
                        subtitle: challenge.reward.description,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'About This Challenge',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Styles.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: Styles.cardDecoration(radius: Radii.card),
                  child: Text(
                    challenge.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.55,
                      color: Styles.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: const BoxDecoration(
              color: Styles.canvas,
              border: Border(top: BorderSide(color: Styles.divider)),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: () {
                    ref
                        .read(challengesProvider.notifier)
                        .toggleJoin(challenge.id);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: challenge.isJoined
                        ? Styles.surfaceHighlight
                        : Styles.primary,
                    foregroundColor: Styles.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.button),
                      side: challenge.isJoined
                          ? const BorderSide(color: Styles.primary)
                          : BorderSide.none,
                    ),
                  ),
                  child: Text(
                    challenge.isJoined
                        ? 'Joined \u00b7 Tap to leave'
                        : 'Join Challenge',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailPill extends StatelessWidget {
  final String label;
  final bool accent;

  const _DetailPill({required this.label, this.accent = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: accent ? Styles.primary : Styles.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accent ? Styles.primaryLight : Styles.borderStrong,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Styles.textPrimary,
        ),
      ),
    );
  }
}

class _DetailInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const _DetailInfoRow({
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Styles.primaryLight),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                  color: Styles.textPrimary,
                ),
              ),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Styles.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Styles.surfaceElevated,
              border: Border.all(color: Styles.borderStrong),
            ),
            child: Icon(icon, color: Styles.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Styles.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}