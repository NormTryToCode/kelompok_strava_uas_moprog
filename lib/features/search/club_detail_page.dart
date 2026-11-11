import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';

class ClubDetailPage extends StatefulWidget {
  final Club club;

  const ClubDetailPage({super.key, required this.club});

  @override
  State<ClubDetailPage> createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage> {
  bool _joined = false;

  @override
  Widget build(BuildContext context) {
    final club = _joined
        ? widget.club.copyWith(memberCount: widget.club.memberCount + 1)
        : widget.club;

    return Scaffold(
      backgroundColor: Styles.background,
      appBar: const AppHeader(title: 'Club', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              club.name,
              style: const TextStyle(
                color: Styles.tabActive,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              club.subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              club.sport.label,
              style: const TextStyle(color: Styles.accent, fontSize: 15),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () => setState(() => _joined = !_joined),
                style: FilledButton.styleFrom(
                  backgroundColor: _joined ? Colors.white12 : Styles.accent,
                  foregroundColor: Styles.tabActive,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  _joined ? 'Joined' : 'Join Club',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}