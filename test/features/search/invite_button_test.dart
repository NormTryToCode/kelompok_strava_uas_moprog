import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/invite_button.dart';

void main() {
  testWidgets('menyalin tautan undangan dan menampilkan konfirmasi',
      (tester) async {
    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        calls.add(call);
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null),
    );

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: InviteButton())),
    );

    await tester.tap(find.text('Invite Friends'));
    await tester.pumpAndSettle();

    expect(find.text('Invite link copied'), findsOneWidget);

    final copied = calls.where((c) => c.method == 'Clipboard.setData').toList();
    expect(copied, hasLength(1));
    expect((copied.first.arguments as Map)['text'], inviteLink);
  });
}