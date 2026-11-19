import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/friends_tab.dart';
import 'package:kelompok_strava_uas_moprog/shared/controllers/follow_controller.dart';

Widget _wrap(FollowController controller) {
  return MaterialApp(
    home: Scaffold(body: FriendsTab(controller: controller)),
  );
}

void main() {
  testWidgets('menampilkan daftar orang dari data dummy', (tester) async {
    await tester.pumpWidget(_wrap(FollowController()));

    expect(find.text('PEOPLE YOU MAY KNOW'), findsOneWidget);
    expect(find.text('Dewi Anggraini'), findsOneWidget);
  });

  testWidgets('mengetuk Follow mengubah tombol menjadi Following',
      (tester) async {
    final controller = FollowController();

    await tester.pumpWidget(_wrap(controller));

    expect(find.text('Following'), findsNothing);

    await tester.tap(find.text('Follow').first);
    await tester.pump();

    expect(find.text('Following'), findsOneWidget);
    expect(controller.followingCount, 1);
  });

  testWidgets('menampilkan sub-tab dan tombol Invite Friends', (tester) async {
    await tester.pumpWidget(_wrap(FollowController()));

    expect(find.text('Suggested'), findsOneWidget);
    expect(find.text('Contacts'), findsOneWidget);
    expect(find.text('QR Code'), findsOneWidget);
    expect(find.text('Invite Friends'), findsOneWidget);
  });

  testWidgets('berpindah ke sub-tab QR Code', (tester) async {
    await tester.pumpWidget(_wrap(FollowController()));

    await tester.tap(find.text('QR Code'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('qr-code')), findsOneWidget);
  });
}