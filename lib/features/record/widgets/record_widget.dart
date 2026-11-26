import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/record/widgets/record_action_card_button.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_page.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_page.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/header_icon_button.dart';

class RecordWidget extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: "Record",
        actions: [
          HeaderIconButton(
            icon: Icons.search,
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const SearchPage())),
          ),
          HeaderIconButton(
            icon: Icons.settings_outlined,
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const SettingsPage())),
          ),
        ],
      ),
      backgroundColor: Styles.canvas,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              RecordActionCardButton(action: "Walk"),
              SizedBox(height: 20),
              RecordActionCardButton(action: "Run"),
              SizedBox(height: 20),
              RecordActionCardButton(action: "Ride"),
              SizedBox(height: 20),
              TextButton(
                onPressed: () => {},
                child: Text("More sports"),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Styles.canvas),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
