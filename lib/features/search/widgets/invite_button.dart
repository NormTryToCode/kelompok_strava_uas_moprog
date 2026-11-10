import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

const String inviteLink = 'https://strava.app.link/EZFTnGxgX7b';

class InviteButton extends StatelessWidget {
  const InviteButton({super.key});

  Future<void> _copyLink(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: inviteLink));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invite link copied')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton(
          onPressed: () => _copyLink(context),
          style: FilledButton.styleFrom(
            backgroundColor: Styles.accent,
            foregroundColor: Styles.tabActive,
            shape: const StadiumBorder(),
          ),
          child: const Text(
            'Invite Friends',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}