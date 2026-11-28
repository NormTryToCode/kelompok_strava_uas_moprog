import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/app_brand.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_footer.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/stride_wordmark.dart';

void main() {
  testWidgets('StrideWordmark menampilkan logo dan teks STRIDE',
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

  test('konstanta AppBrand menggunakan branding Stride', () {
    expect(AppBrand.name, 'Stride');
    expect(AppBrand.wordmark, 'STRIDE');
    expect(AppBrand.inviteLink.toLowerCase().contains('strava'), isFalse);
  });
}