import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/friends_tab.dart';
import 'package:kelompok_strava_uas_moprog/shared/controllers/follow_controller.dart';

void main() {
  testWidgets('menampilkan daftar orang dari data dummy', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: FriendsTab(controller: FollowController())),
      ),
    );

    expect(find.text('PEOPLE YOU MAY KNOW'), findsOneWidget);
    expect(find.text('Dewi Anggraini'), findsOneWidget);
  });

  testWidgets('mengetuk Follow mengubah tombol menjadi Following', (tester) async {
    final controller = FollowController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: FriendsTab(controller: controller)),
      ),
    );

    expect(find.text('Following'), findsNothing);

    await tester.tap(find.text('Follow').first);
    await tester.pump();

    expect(find.text('Following'), findsOneWidget);
    expect(controller.followingCount, 1);
  });
}