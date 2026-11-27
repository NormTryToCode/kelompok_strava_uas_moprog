import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/app_brand.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/data/dummy_notifications.dart';
import 'package:kelompok_strava_uas_moprog/features/search/data/dummy_people.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_footer.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/stride_wordmark.dart';

void main() {
  testWidgets('StrideWordmark menampilkan ikon petir dan teks STRIDE',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: StrideWordmark())),
    );

    expect(find.text(AppBrand.wordmark), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('AppFooter menampilkan 5 tab dan memanggil onTap saat diketuk',
      (tester) async {
    int? tappedIndex;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: AppFooter(
            currentIndex: 0,
            onTap: (index) => tappedIndex = index,
          ),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Maps'), findsOneWidget);
    expect(find.text('Record'), findsOneWidget);
    expect(find.text('Groups'), findsOneWidget);
    expect(find.text('You'), findsOneWidget);

    await tester.tap(find.text('Groups'));
    await tester.pump();

    expect(tappedIndex, 3);
  });

  test('data dummy notifikasi dan pencarian tidak lagi menyebut Strava', () {
    for (final item in buildDummyNotifications()) {
      expect(item.title.toLowerCase().contains('strava'), isFalse);
      expect(item.body.toLowerCase().contains('strava'), isFalse);
    }
    for (final person in buildDummyPeople()) {
      expect(person.tag.toLowerCase().contains('strava'), isFalse);
    }
    expect(AppBrand.inviteLink.toLowerCase().contains('strava'), isFalse);
  });
}