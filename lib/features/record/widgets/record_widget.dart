import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';

class RecordWidget extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: "Record"),
      backgroundColor: Styles.canvas,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text("Walk", style: TextStyle(color: Styles.textSecondary)),
            SizedBox(height: 10),
            Text("Run", style: TextStyle(color: Styles.textSecondary)),
            SizedBox(height: 10),
            Text("Ride", style: TextStyle(color: Styles.textSecondary)),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => {},
              child: Text("More sports"),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Styles.canvas),
              ),
            ),
            TextButton(
              onPressed: () => {},
              child: Text(
                "Start Free Trial",
                style: TextStyle(color: Styles.textPrimary),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Styles.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
