import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_list_page.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/manual_activity_page.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/create_feed_post_page.dart';
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
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const CreateFeedPostPage()),
      );
      return;
    case AddAction.photo:
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const CreateFeedPostPage(pickPhotoOnOpen: true),
        ),
      );
      return;
  }
}