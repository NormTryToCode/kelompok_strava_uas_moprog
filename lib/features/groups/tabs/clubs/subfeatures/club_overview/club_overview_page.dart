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
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_overview/club_members_page.dart';

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
  bool _processing = false;

  Future<void> _onDeleteOrLeaveClub(Club club) async {
    if (_processing) return;

    final isOwner = club.isOwner;
    final confirmed = await showConfirmDeleteDialog(
      context,
      title: isOwner ? 'Delete club?' : 'Leave club?',
      message: isOwner
          ? '"${club.name}" will be permanently removed from your clubs.'
          : 'You will no longer be a member of "${club.name}".',
      confirmLabel: isOwner ? 'Delete' : 'Leave',
    );

    if (!confirmed || !mounted) return;
    setState(() => _processing = true);

    try {
      final notifier = ref.read(clubsProvider.notifier);
      if (isOwner) {
        await notifier.deleteClub(club.id);
      } else {
        await notifier.leaveClub(club.id);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _processing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isOwner
                ? 'Could not delete club. Please try again.'
                : 'Could not leave club. Please try again.',
          ),
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
    final isOwner = club.isOwner;

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppBar(
        backgroundColor: Styles.canvas,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Styles.textPrimary,
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
            onViewAll: () => ClubMembersPage.open(context, club),
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
                          color: Styles.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'View guidelines for clubs and members',
                        style: TextStyle(
                          fontSize: 13,
                          color: Styles.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Styles.textSecondary),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _processing ? null : () => _onDeleteOrLeaveClub(club),
              style: ElevatedButton.styleFrom(
                backgroundColor: isOwner ? Styles.danger : Styles.accent,
                foregroundColor: Styles.textPrimary,
                disabledBackgroundColor:
                    (isOwner ? Styles.danger : Styles.accent).withAlpha(110),
                disabledForegroundColor: Styles.textSecondary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Radii.button),
                ),
              ),
              icon: Icon(
                isOwner ? Icons.delete_outline : Icons.logout,
                size: 20,
              ),
              label: Text(
                _processing
                    ? (isOwner ? 'Deleting club...' : 'Leaving club...')
                    : (isOwner ? 'Delete Club' : 'Leave Club'),
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