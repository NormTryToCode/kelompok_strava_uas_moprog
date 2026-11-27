import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_history_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/shared/providers/follow_provider.dart';

final userDataHydratorProvider = Provider<Future<void> Function()>((ref) {
  return () => Future.wait([
        ref.read(followProvider.notifier).load(),
        ref.read(searchHistoryProvider.notifier).load(),
        ref.read(notificationsProvider.notifier).load(),
        ref.read(settingsProvider.notifier).load(),
        ref.read(activityProvider.notifier).load(),
      ]);
});