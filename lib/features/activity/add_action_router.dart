import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_list_page.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/manual_activity_page.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/widgets/club_picker_sheet.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/club_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_posts/create_post_page.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/add_menu_button.dart';

Future<void> openAddAction(BuildContext context, AddAction action) async {
  switch (action) {
    case AddAction.manualActivity:
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const ManualActivityPage()),
      );
      return;
    case AddAction.activityHistory:
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const ActivityListPage()),
      );
      return;
    case AddAction.post:
    case AddAction.photo:
      await _openCreatePostFlow(
        context,
        pickPhotoOnOpen: action == AddAction.photo,
      );
      return;
  }
}

Future<void> _openCreatePostFlow(
  BuildContext context, {
  required bool pickPhotoOnOpen,
}) async {
  ProviderContainer? container;
  try {
    container = ProviderScope.containerOf(context, listen: false);
  } catch (_) {
    container = null;
  }

  List<Club> clubs = const <Club>[];
  if (container != null) {
    final cached = container.read(clubsProvider).valueOrNull;
    if (cached != null) {
      clubs = cached;
    } else {
      try {
        clubs = await container.read(clubsProvider.future);
      } catch (_) {
        clubs = const <Club>[];
      }
    }
  }

  if (!context.mounted) return;

  if (clubs.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Create a club in Groups first to publish a post.'),
      ),
    );
    return;
  }

  final Club? targetClub = clubs.length == 1
      ? clubs.single
      : await showClubPickerSheet(context, clubs);

  if (targetClub == null || !context.mounted) return;

  final created = await CreatePostPage.open(
    context,
    targetClub,
    pickPhotoOnOpen: pickPhotoOnOpen,
  );

  if (created != null && container != null) {
    container.read(notificationsProvider.notifier).addNotification(
          title: 'Post published in ${targetClub.name}',
          body: created.title.isNotEmpty
              ? created.title
              : 'Your club post is now live.',
          preference: NotificationPref.clubEvents,
        );
  }
}