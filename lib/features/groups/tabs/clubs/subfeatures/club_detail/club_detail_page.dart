import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_channels/club_channels_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_action_buttons.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_channels_section.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_detail_header.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_events_section.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_posts_section.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_posts/create_post_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/event_creation_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/section_title.dart';

class ClubDetailPage extends StatefulWidget {
  final Club club;

  const ClubDetailPage({super.key, required this.club});

  static Future<void> open(BuildContext context, Club club) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(builder: (_) => ClubDetailPage(club: club)),
    );
  }

  @override
  State<ClubDetailPage> createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage> {
  final _postsSectionKey = GlobalKey();

  void _comingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon')),
    );
  }

  Future<void> _createEvent() async {
    final event = await EventCreationPage.open(context, widget.club);
    if (event == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${event.name} created')),
    );
  }

  Future<void> _createPost() async {
    final post = await CreatePostPage.open(context, widget.club);
    if (post == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post published')),
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
    return Scaffold(
      backgroundColor: Styles.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createPost,
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
              club: widget.club,
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
                    onTap: _comingSoon,
                    onPostsTap: _scrollToPosts,
                  ),
                  const SizedBox(height: 28),
                  ClubChannelsSection(
                    clubId: widget.club.id,
                    onTap: () => ClubChannelsPage.open(context, widget.club),
                  ),
                  const SizedBox(height: 28),
                  ClubEventsSection(onCreateEvent: _createEvent),
                  const SizedBox(height: 28),
                  KeyedSubtree(
                    key: _postsSectionKey,
                    child: ClubPostsSection(club: widget.club),
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