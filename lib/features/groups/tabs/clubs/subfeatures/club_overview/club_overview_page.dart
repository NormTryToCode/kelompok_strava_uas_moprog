import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/club_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_overview/widgets/club_members_card.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_overview/widgets/club_overview_sheets.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_overview/widgets/club_overview_summary_card.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/app_buttons.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/confirm_delete_dialog.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/count_pill.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/section_title.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class ClubOverviewPage extends ConsumerStatefulWidget {
  final Club club;

  const ClubOverviewPage({super.key, required this.club});

  static Future<bool?> open(BuildContext context, Club club) {
    return Navigator.of(context, rootNavigator: true).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => ClubOverviewPage(club: club)),
    );
  }

  @override
  ConsumerState<ClubOverviewPage> createState() => _ClubOverviewPageState();
}

class _ClubOverviewPageState extends ConsumerState<ClubOverviewPage> {
  bool _deleting = false;

  Future<void> _onDeleteClub(Club club) async {
    if (_deleting) return;

    final confirmed = await showConfirmDeleteDialog(
      context,
      title: 'Delete club?',
      message: '"${club.name}" will be permanently removed from your clubs.',
    );

    if (!confirmed || !mounted) return;
    setState(() => _deleting = true);

    try {
      await ref.read(clubsProvider.notifier).deleteClub(club.id);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _deleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not delete club. Please try again.'),
        ),
      );
    }
  }

  Future<void> _onReportClub(Club club) async {
    final reason = await showReportClubSheet(context, club);
    if (reason == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Report submitted. Thank you for keeping the community safe.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clubs = ref.watch(clubsProvider).valueOrNull ?? const <Club>[];
    final club = clubs.firstWhere(
      (c) => c.id == widget.club.id,
      orElse: () => widget.club,
    );

    return Scaffold(
      backgroundColor: Styles.background,
      appBar: AppBar(
        backgroundColor: Styles.background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          'Overview',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          ClubOverviewSummaryCard(club: club),
          const SizedBox(height: 24),
          SectionTitle(
            'Members',
            trailing: CountPill(count: club.memberCount),
          ),
          const SizedBox(height: 12),
          ClubMembersCard(
            club: club,
            onViewAll: () => showClubMembersSheet(context, club),
          ),
          const SizedBox(height: 28),
          const SectionTitle('Actions'),
          const SizedBox(height: 12),
          SoftCard(
            onTap: () => showCommunityStandardsSheet(context),
            padding: const EdgeInsets.all(14),
            radius: 18,
            child: const Row(
              children: [
                IconBubble(Icons.verified_user_outlined, size: 42),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Community standards',
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'View guidelines for clubs and members',
                        style: TextStyle(
                          fontSize: 13,
                          color: Styles.tabInactive,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Styles.tabInactive),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _deleting ? null : () => _onDeleteClub(club),
              style: ElevatedButton.styleFrom(
                backgroundColor: Styles.accent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Styles.accent.withAlpha(110),
                disabledForegroundColor: Colors.white70,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Radii.button),
                ),
              ),
              icon: const Icon(Icons.delete_outline, size: 20),
              label: Text(
                _deleting ? 'Deleting club...' : 'Delete Club',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GhostButton(
            label: 'Report Club',
            icon: Icons.flag_outlined,
            onPressed: () => _onReportClub(club),
          ),
        ],
      ),
    );
  }
}