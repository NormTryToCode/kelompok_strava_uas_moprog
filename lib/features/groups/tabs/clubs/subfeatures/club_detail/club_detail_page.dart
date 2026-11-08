import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/event_creation_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_action_buttons.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_channels_section.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_detail_header.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_events_section.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_info_row.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_post_bar.dart';

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
      backgroundColor: Styles.surface,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClubDetailHeader(
                    onBack: () => Navigator.of(context).pop(),
                    onSettings: comingSoon,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          club.name,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClubInfoRow(club: club),
                        if (club.types.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            club.typeLabel,
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                        if (club.description.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            club.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Styles.tabInactive,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ClubActionButtons(onTap: comingSoon),
                  const SizedBox(height: 28),
                  ClubChannelsSection(onTap: comingSoon),
                  ClubEventsSection(onCreateEvent: () => _createEvent(context)),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          ClubPostBar(onTap: comingSoon),
        ],
      ),
    );
  }
}
