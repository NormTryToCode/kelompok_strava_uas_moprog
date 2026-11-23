import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/manual_activity_page.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/add_menu_button.dart';

void openAddAction(BuildContext context, AddAction action) {
  switch (action) {
    case AddAction.manualActivity:
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const ManualActivityPage()),
      );
    case AddAction.post:
    case AddAction.photo:
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coming soon')),
      );
  }
}