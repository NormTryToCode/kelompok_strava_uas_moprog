import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_invite_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/invite_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_store.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notifications_page.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';

class _StubInvitesNotifier extends MyPendingInvitesNotifier {
  final List<ClubInvite> initial;
  int acceptCalls = 0;
  int declineCalls = 0;

  _StubInvitesNotifier(this.initial);

  @override
  Future<List<ClubInvite>> build() async => initial;

  @override
  Future<void> accept(ClubInvite invite) async {
    acceptCalls++;
    state = const AsyncData([]);
  }

  @override
  Future<void> decline(ClubInvite invite) async {
    declineCalls++;
    state = const AsyncData([]);
  }
}

ClubInvite _invite() => ClubInvite(
      clubId: 'club1',
      clubName: 'Stride Runners',
      friendId: 'u1',
      friendName: 'Angga',
      username: 'angga',
      invitedByName: 'Louis',
      invitedAt: DateTime(2026, 11, 28),
    );

void main() {
  testWidgets('Accept undangan klub memanggil accept dan menambah notifikasi',
      (tester) async {
    final stub = _StubInvitesNotifier([_invite()]);
    final container = ProviderContainer(
      overrides: [
        myPendingInvitesProvider.overrideWith(() => stub),
        notificationStoreProvider.overrideWithValue(MemoryNotificationStore()),
        settingsStoreProvider.overrideWithValue(MemorySettingsStore()),
      ],
    );
    addTearDown(container.dispose);

    await container.read(myPendingInvitesProvider.future);
    expect(container.read(unreadCountProvider), 1);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: NotificationsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('CLUB INVITATIONS'), findsOneWidget);
    await tester.tap(find.text('Accept'));
    await tester.pumpAndSettle();

    expect(stub.acceptCalls, 1);
    expect(find.text('CLUB INVITATIONS'), findsNothing);
    expect(
      container.read(notificationsProvider).first.title,
      'Joined Stride Runners',
    );
  });

  testWidgets('Decline undangan klub menghapus kartu tanpa notifikasi gabung',
      (tester) async {
    final stub = _StubInvitesNotifier([_invite()]);
    final container = ProviderContainer(
      overrides: [
        myPendingInvitesProvider.overrideWith(() => stub),
        notificationStoreProvider.overrideWithValue(MemoryNotificationStore()),
        settingsStoreProvider.overrideWithValue(MemorySettingsStore()),
      ],
    );
    addTearDown(container.dispose);

    await container.read(myPendingInvitesProvider.future);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: NotificationsPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Decline'));
    await tester.pumpAndSettle();

    expect(stub.declineCalls, 1);
    expect(container.read(notificationsProvider), isEmpty);
  });
}