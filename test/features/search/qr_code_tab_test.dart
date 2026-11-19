import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/qr_code_tab.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/qr_placeholder_painter.dart';

void main() {
  testWidgets('menampilkan kode QR dan tombol scan', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: QrCodeTab())),
    );

    expect(find.byKey(const Key('qr-code')), findsOneWidget);
    expect(find.text('Your QR code'), findsOneWidget);

    await tester.tap(find.text('Scan a code'));
    await tester.pump();

    expect(find.text('Scanner is not available in this demo'), findsOneWidget);
  });

  test('shouldRepaint hanya true saat seed berubah', () {
    const painter = QrPlaceholderPainter(seed: 'a');

    expect(painter.shouldRepaint(const QrPlaceholderPainter(seed: 'a')), isFalse);
    expect(painter.shouldRepaint(const QrPlaceholderPainter(seed: 'b')), isTrue);
  });
}