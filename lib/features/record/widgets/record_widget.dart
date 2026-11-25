import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';

class RecordWidget extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: "Record"),
      backgroundColor: Styles.canvas,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              TextButton(
                onPressed: () {},
                child: Column(
                  children: [
                    Text("Walk", style: TextStyle(color: Styles.canvas)),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Start",
                        style: TextStyle(color: Styles.textPrimary),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Styles.primary,
                        minimumSize: Size(340.0, 40.0),
                      ),
                    ),
                  ],
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Styles.textPrimary,
                  alignment: Alignment.topLeft,
                  minimumSize: Size(370, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),

              TextButton(
                onPressed: () {},
                child: Column(
                  children: [
                    Text("Run", style: TextStyle(color: Styles.canvas)),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Start",
                        style: TextStyle(color: Styles.textPrimary),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Styles.primary,
                        minimumSize: Size(340.0, 40.0),
                      ),
                    ),
                  ],
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Styles.textPrimary,
                  minimumSize: Size(370, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: Column(
                  children: [
                    Text("Ride", style: TextStyle(color: Styles.canvas)),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Start",
                        style: TextStyle(color: Styles.textPrimary),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Styles.primary,
                        minimumSize: Size(340.0, 40.0),
                      ),
                    ),
                  ],
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Styles.textPrimary,
                  minimumSize: Size(370, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
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
