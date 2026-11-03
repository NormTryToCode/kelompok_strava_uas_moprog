import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/groups_page.dart';

void main() {
  // runApp(const MyApp());
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false ,
      home: const Scaffold(
        body: SafeArea(child: GroupsPage())
      )
    )
  );
}

