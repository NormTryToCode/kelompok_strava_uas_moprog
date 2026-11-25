import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class RecordActionCardButton extends StatelessWidget {
  final String action;

  const RecordActionCardButton({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Column(
        children: [
          Text('$action', style: TextStyle(color: Styles.canvas)),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {},
            child: Text("Start", style: TextStyle(color: Styles.textPrimary)),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
