import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/add_action_router.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/add_menu_button.dart';

Widget _host(AddAction action) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () => openAddAction(context, action),
          child: const Text('go'),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('Manual Activity membuka halaman form', (tester) async {
    await tester.pumpWidget(_host(AddAction.manualActivity));

    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();

    expect(find.text('Manual Activity'), findsOneWidget);
  });

  testWidgets('Post dan Photo menampilkan pesan Coming soon', (tester) async {
    await tester.pumpWidget(_host(AddAction.post));

    await tester.tap(find.text('go'));
    await tester.pump();

    expect(find.text('Coming soon'), findsOneWidget);
  });
}