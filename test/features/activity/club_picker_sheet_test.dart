import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/widgets/club_picker_sheet.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';

Club _club(String id, String name) {
  return Club(
    id: id,
    name: name,
    description: 'Community club',
    sport: ClubSport.option.firstWhere((s) => s.id == 'running'),
    types: const [],
    privacy: ClubPrivacy.public,
    isGlobal: true,
    location: null,
    memberCount: 12,
    createdAt: DateTime(2026, 11, 23),
  );
}

void main() {
  testWidgets('menampilkan pesan kosong saat daftar klub kosong',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ClubPickerSheet(clubs: const [], onSelected: (_) {}),
        ),
      ),
    );

    expect(find.text('Choose a club'), findsOneWidget);
    expect(
      find.text(
        'No clubs available yet. Create a club in the Groups tab first.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('mengetuk klub memanggil callback dengan klub yang dipilih',
      (tester) async {
    Club? picked;
    final clubs = [_club('c1', 'Stride Runners'), _club('c2', 'Stride Riders')];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ClubPickerSheet(
            clubs: clubs,
            onSelected: (club) => picked = club,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Stride Riders'));
    await tester.pump();

    expect(picked?.id, 'c2');
  });
}