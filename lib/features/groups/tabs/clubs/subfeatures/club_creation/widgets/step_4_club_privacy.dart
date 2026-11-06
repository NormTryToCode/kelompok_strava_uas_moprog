import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/privacy_option_tile.dart';

class Step4ClubPrivacy extends StatelessWidget {
  final ClubPrivacy selected;
  final ValueChanged<ClubPrivacy> onChanged;

  const Step4ClubPrivacy({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 28, 20, 0),
          child: _Heading(),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 32, 20, 8),
          child: Text(
            'WHO CAN JOIN',
            style: TextStyle(
              fontSize: 13,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
              color: Styles.tabInactive,
            ),
          ),
        ),
        for (final privacy in ClubPrivacy.option)
          PrivacyOptionTile(
            privacy: privacy,
            selected: privacy.id == selected.id,
            onTap: () => onChanged(privacy),
          ),
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Who can join?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Pick how people get into your club.',
          style: TextStyle(fontSize: 16, color: Styles.tabInactive),
        ),
      ],
    );
  }
}
