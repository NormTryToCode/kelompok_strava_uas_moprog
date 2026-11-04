import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/header_icon_button.dart';

void main() {
  testWidgets('AppHeader menampilkan judul, aksi, dan badge', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppHeader(
            title: 'Groups',
            actions: [
              HeaderIconButton(icon: Icons.search),
              HeaderIconButton(icon: Icons.notifications_none, badgeCount: 3),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Groups'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('badge tidak tampil saat jumlahnya nol', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppHeader(
            title: 'Home',
            actions: [HeaderIconButton(icon: Icons.notifications_none)],
          ),
        ),
      ),
    );

    expect(find.text('0'), findsNothing);
  });
}