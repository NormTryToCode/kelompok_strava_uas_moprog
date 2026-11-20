import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class FeedbackThankYouDialog extends StatelessWidget {
  final VoidCallback onConfirmOk;

  const FeedbackThankYouDialog({
    super.key,
    required this.onConfirmOk,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Styles.surface,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terima Kasih',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Styles.tabActive,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Terima Kasih, Ulasanmu Sangat Berarti Bagi Kami',
              style: TextStyle(
                fontSize: 15,
                color: Styles.tabActive,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    onConfirmOk();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    child: Text(
                      'Oke',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Styles.accent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}