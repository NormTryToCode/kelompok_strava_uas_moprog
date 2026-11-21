import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/app_buttons.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';

Future<void> showClubMembersSheet(BuildContext context, Club club) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Styles.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SheetHandle(),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Club Members',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    club.memberLabel,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Palette.teal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Palette.fieldFill,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Palette.cardBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Palette.selectedFill,
                        border: Border.all(color: Palette.teal, width: 1.5),
                      ),
                      child: const Text(
                        'Y',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Palette.teal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'You',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Owner \u00b7 ${club.locationLabel}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Styles.tabInactive,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.verified_user_outlined,
                      color: Palette.teal,
                      size: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Invited athletes who join this club will appear in this list.',
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.4,
                  color: Styles.tabInactive,
                ),
              ),
              const SizedBox(height: 18),
              PrimaryButton(
                label: 'Close',
                onPressed: () => Navigator.of(sheetContext).pop(),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> showCommunityStandardsSheet(BuildContext context) {
  const guidelines = [
    (
      Icons.handshake_outlined,
      'Be respectful and inclusive',
      'Treat all club members with respect in posts, comments, and channels.',
    ),
    (
      Icons.directions_run,
      'Keep activities authentic',
      'Share genuine workouts, accurate route tips, and honest event details.',
    ),
    (
      Icons.shield_outlined,
      'Protect member safety',
      'Avoid sharing private addresses or unsafe routes without clear warnings.',
    ),
  ];

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Styles.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SheetHandle(),
              const SizedBox(height: 16),
              const Text(
                'Community Standards',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Guidelines to keep clubs welcoming, safe, and motivating for everyone.',
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.4,
                  color: Styles.tabInactive,
                ),
              ),
              const SizedBox(height: 18),
              for (var i = 0; i < guidelines.length; i++) ...[
                if (i > 0) const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconBubble(guidelines[i].$1, size: 40),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            guidelines[i].$2,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            guidelines[i].$3,
                            style: const TextStyle(
                              fontSize: 13.5,
                              height: 1.4,
                              color: Styles.tabInactive,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 22),
              PrimaryButton(
                label: 'Got it',
                onPressed: () => Navigator.of(sheetContext).pop(),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<String?> showReportClubSheet(BuildContext context, Club club) {
  const reasons = [
    'Spam or misleading information',
    'Inappropriate name or imagery',
    'Harassment or hate speech',
    'Impersonation of another club',
    'Other community violation',
  ];

  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Styles.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      String? selectedReason;

      return StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SheetHandle(),
                  const SizedBox(height: 16),
                  Text(
                    'Report "${club.name}"',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Select the reason that best describes the issue.',
                    style: TextStyle(fontSize: 13.5, color: Styles.tabInactive),
                  ),
                  const SizedBox(height: 14),
                  for (var i = 0; i < reasons.length; i++) ...[
                    if (i > 0) const SizedBox(height: 8),
                    Material(
                      color: selectedReason == reasons[i]
                          ? Palette.selectedFill
                          : Palette.fieldFill,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: selectedReason == reasons[i]
                              ? Palette.teal
                              : Palette.cardBorder,
                          width: selectedReason == reasons[i] ? 1.5 : 1,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () =>
                            setModalState(() => selectedReason = reasons[i]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 13,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  reasons[i],
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Icon(
                                selectedReason == reasons[i]
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                size: 20,
                                color: selectedReason == reasons[i]
                                    ? Palette.teal
                                    : Styles.tabInactive,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  PrimaryButton(
                    label: 'Submit report',
                    onPressed: selectedReason == null
                        ? null
                        : () => Navigator.of(sheetContext).pop(selectedReason),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Styles.inactive,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}