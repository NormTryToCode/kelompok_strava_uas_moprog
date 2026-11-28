import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_store.dart';
import 'package:kelompok_strava_uas_moprog/features/search/club_detail_page.dart';
import 'package:kelompok_strava_uas_moprog/features/search/joined_clubs_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';

const _club = SearchClub(
  id: 'c1',
  name: 'Jakarta Sunrise Runners',
  sport: SportType.running,
  memberCount: 1000,
  city: 'Jakarta',
);

Widget _page({ProviderContainer? container}) {
  const app = MaterialApp(home: SearchClubDetailPage(club: _club));
  if (container != null) {
    return UncontrolledProviderScope(container: container, child: app);
  }
  return ProviderScope(
    overrides: [
      joinedClubsStoreProvider.overrideWithValue(MemoryJoinedClubsStore()),
      settingsStoreProvider.overrideWithValue(MemorySettingsStore()),
      notificationStoreProvider.overrideWithValue(MemoryNotificationStore()),
      pendingClubInvitesProvider.overrideWithValue(const []),
    ],
    child: app,
  );
}

void main() {
  testWidgets('menampilkan informasi klub', (tester) async {
    await tester.pumpWidget(_page());

    expect(find.text('Jakarta Sunrise Runners'), findsOneWidget);
    expect(find.text('1,000 runners • Jakarta'), findsOneWidget);
    expect(find.text('Running'), findsOneWidget);
    expect(find.text('Join Club'), findsOneWidget);
  });

  testWidgets(
      'Join Club menambah anggota, berubah Joined, dan memicu notifikasi',
      (tester) async {
    final container = ProviderContainer(
      overrides: [
        joinedClubsStoreProvider.overrideWithValue(MemoryJoinedClubsStore()),
        settingsStoreProvider.overrideWithValue(MemorySettingsStore()),
        notificationStoreProvider.overrideWithValue(MemoryNotificationStore()),
        pendingClubInvitesProvider.overrideWithValue(const []),
      ],
    );
    addTearDown(container.dispose);
    final unreadBefore = container.read(unreadCountProvider);

    await tester.pumpWidget(_page(container: container));

    await tester.tap(find.text('Join Club'));
    await tester.pump();

    expect(find.text('Joined'), findsOneWidget);
    expect(find.text('1,001 runners • Jakarta'), findsOneWidget);
    expect(container.read(unreadCountProvider), unreadBefore + 1);
    expect(
      container.read(notificationsProvider).first.title,
      'Joined Jakarta Sunrise Runners',
    );
  });

  testWidgets('mengetuk Joined membatalkan keanggotaan', (tester) async {
    await tester.pumpWidget(_page());

    await tester.tap(find.text('Join Club'));
    await tester.pump();
    await tester.tap(find.text('Joined'));
    await tester.pump();

    expect(find.text('Join Club'), findsOneWidget);
    expect(find.text('1,000 runners • Jakarta'), findsOneWidget);
  });
}