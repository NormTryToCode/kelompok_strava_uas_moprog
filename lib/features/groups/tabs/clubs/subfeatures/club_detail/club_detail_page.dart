import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_action_buttons.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_channels_section.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_detail_header.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_events_section.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/event_creation_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/section_title.dart';

class ClubDetailPage extends StatelessWidget {
  final Club club;

  const ClubDetailPage({super.key, required this.club});

  static Future<void> open(BuildContext context, Club club) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(builder: (_) => ClubDetailPage(club: club)),
    );
  }

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon')),
    );
  }

  Future<void> _createEvent(BuildContext context) async {
    final event = await EventCreationPage.open(context, club);
    if (event == null || !context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${event.name} created')),
    );
  }

  @override
  Widget build(BuildContext context) {
    void comingSoon() => _comingSoon(context);

    return Scaffold(
      backgroundColor: Styles.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: comingSoon,
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
              onSettings: comingSoon,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle('Quick actions'),
                  const SizedBox(height: 12),
                  ClubActionButtons(onTap: comingSoon),
                  const SizedBox(height: 28),
                  ClubChannelsSection(onTap: comingSoon),
                  const SizedBox(height: 28),
                  ClubEventsSection(onCreateEvent: () => _createEvent(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
