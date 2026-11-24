import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/club_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_channels/club_channels_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_action_buttons.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_channels_section.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_detail_header.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_events_section.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_posts_section.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_edit/edit_club_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_posts/create_post_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/event_creation_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_events/club_events_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_overview/club_overview_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_share/share_club_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/section_title.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_invite/invite_club_page.dart';

class ClubDetailPage extends ConsumerStatefulWidget {
  final Club club;

  const ClubDetailPage({super.key, required this.club});

  static Future<void> open(BuildContext context, Club club) {
    return Navigator.of(
      context,
      rootNavigator: true,
    ).push(MaterialPageRoute<void>(builder: (_) => ClubDetailPage(club: club)));
  }

  @override
  ConsumerState<ClubDetailPage> createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends ConsumerState<ClubDetailPage> {
  final _postsSectionKey = GlobalKey();

  void _comingSoon() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Coming soon')));
  }

  Future<void> _editClub(Club club) async {
    if(!club.canManage) return;
    final updated  = await EditClubPage.open(context, club);
    if(updated == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Club details updated')),
    );
  }

  Future<void> _createEvent(Club club) async {
    final event = await EventCreationPage.open(context, club);
    if (event == null || !mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${event.name} created')));
  }

  Future<void> _createPost(Club club) async {
    final post = await CreatePostPage.open(context, club);
    if (post == null || !mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Post published')));
  }

  Future<void> _openOverview(Club club) async {
    final deleted = await ClubOverviewPage.open(context, club);
    if (deleted != true || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          club.isOwner ? '${club.name} deleted' : 'Left ${club.name}',
        ),
      ),
    );
  }

  void _scrollToPosts() {
    final target = _postsSectionKey.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
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
      backgroundColor: Styles.canvas,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createPost(club),
        backgroundColor: Styles.accent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.button),
        ),
        icon: const Icon(Icons.edit_outlined),
        label: const Text(
          'New post',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClubDetailHeader(
              club: club,
              onBack: () => Navigator.of(context).pop(),
              onSettings: _comingSoon,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle('Quick actions'),
                  const SizedBox(height: 12),
                  ClubActionButtons(
                    canManage: club.canManage,
                    onTap: _comingSoon,
                    onInviteTap: () => InviteClubPage.open(context, club),
                    onEditDetailsTap: () => _editClub(club),
                    onShareTap: () => ShareClubPage.open(context, club),
                    onEventsTap: () => ClubEventsPage.open(context, club),
                    onOverviewTap: () => _openOverview(club),
                    onPostsTap: _scrollToPosts,
                  ),
                  const SizedBox(height: 28),
                  ClubChannelsSection(
                    clubId: club.id,
                    onTap: () => ClubChannelsPage.open(context, club),
                  ),
                  const SizedBox(height: 28),
                  ClubEventsSection(
                    clubId: club.id,
                    onCreateEvent: () => _createEvent(club),
                    onViewAll: () => ClubEventsPage.open(context, club),
                  ),
                  const SizedBox(height: 28),
                  KeyedSubtree(
                    key: _postsSectionKey,
                    child: ClubPostsSection(club: club),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

