import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class UnsavedChangesDialog extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onDiscard;

  const UnsavedChangesDialog({
    super.key,
    required this.onSave,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Styles.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.card),
        side: const BorderSide(color: Styles.borderStrong, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Unsaved Passport Changes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Styles.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Save your Athlete Passport updates before leaving this screen?',
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Styles.textSecondary,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onDiscard();
                  },
                  child: const Text(
                    'Discard',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Styles.danger,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.primary,
                    foregroundColor: Styles.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.chip),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    onSave();
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
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

class SavingProfileDialog extends StatelessWidget {
  const SavingProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Styles.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.card),
        side: const BorderSide(color: Styles.borderStrong, width: 1.2),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Styles.primaryLight),
            SizedBox(width: 20),
            Text(
              'Syncing Passport...',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: Styles.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}