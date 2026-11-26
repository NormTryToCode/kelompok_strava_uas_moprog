import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_providers.dart';
import 'package:kelompok_strava_uas_moprog/features/home/data/weekly_activity_repository.dart';
import 'package:kelompok_strava_uas_moprog/features/home/data/weekly_activity_seeder.dart';
import 'package:kelompok_strava_uas_moprog/features/home/models/weekly_activity_model.dart';
import 'package:kelompok_strava_uas_moprog/features/home/providers/weekly_activity_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/home/widgets/streak_chart_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakePrefsAsync implements SharedPreferencesAsync {
  final Map<String, String> _strings = {};

  @override
  Future<String?> getString(String key) async => _strings[key];

  @override
  Future<void> setString(String key, String value) async {
    _strings[key] = value;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
      'WeeklyActivityData computes Monday, accumulates metrics, and round-trips JSON',
      () {
    final thursday = DateTime(2026, 11, 26); // Thursday
    final monday = WeeklyActivityData.mondayOfWeek(thursday);
    expect(WeeklyActivityData.formatDateIso(monday), '2026-11-23');

    final empty = WeeklyActivityData.empty(
      userId: 'user_1',
      referenceDate: thursday,
      isSeeded: true,
    );
    expect(empty.id, 'user_1_2026-11-23');
    expect(empty.days.length, 7);
    expect(empty.activeDaysCount, 0);

    final updated = empty.withAddedMetrics(
      date: thursday,
      distanceKm: 4.25,
      calories: 320,
      steps: 5400,
    );
    expect(updated.isSeeded, isFalse);
    expect(updated.totalDistanceKm, 4.25);
    expect(updated.totalCalories, 320);
    expect(updated.totalSteps, 5400);
    expect(updated.activeDaysCount, 1);
    expect(updated.entryForWeekday(DateTime.thursday).distanceKm, 4.25);

    final restored = WeeklyActivityData.fromJson(
      updated.toJson(),
      id: updated.id,
    );
    expect(restored.id, updated.id);
    expect(restored.totalDistanceKm, 4.25);
    expect(restored.totalCalories, 320);
    expect(restored.totalSteps, 5400);
    expect(restored.days.length, 7);
  });

  test(
      'WeeklyActivitySeeder seeds dummy week once and preserves recorded updates',
      () async {
    final repo = MemoryWeeklyActivityRepository();
    final refDate = DateTime(2026, 11, 26);

    final seeded = await WeeklyActivitySeeder.seedCurrentWeekIfMissing(
      userId: 'user_1',
      repository: repo,
      referenceDate: refDate,
    );
    expect(seeded.isSeeded, isTrue);
    expect(seeded.days.length, 7);
    expect(seeded.totalDistanceKm, 37.0);
    expect(seeded.totalCalories, 2830);
    expect(seeded.totalSteps, 54200);

    await repo.addActivityMetrics(
      userId: 'user_1',
      date: refDate,
      distanceKm: 3.0,
      calories: 200,
      steps: 4000,
    );

    final reloaded = await WeeklyActivitySeeder.seedCurrentWeekIfMissing(
      userId: 'user_1',
      repository: repo,
      referenceDate: refDate,
    );
    expect(reloaded.isSeeded, isFalse);
    expect(reloaded.totalDistanceKm, 40.0);
    expect(reloaded.totalCalories, 3030);
    expect(reloaded.totalSteps, 58200);
  });

  test(
      'FirestoreWeeklyActivityRepository saves expected schema and falls back to local cache',
      () async {
    final prefs = _FakePrefsAsync();
    String? savedCollection;
    String? savedId;
    WeeklyJsonMap? savedData;
    var failRemote = false;

    final repo = FirestoreWeeklyActivityRepository(
      prefs: prefs,
      readByUser: (collection, field, value) async {
        if (failRemote) throw Exception('offline');
        if (savedData == null) return const [];
        return [
          {...savedData!, 'id': savedId},
        ];
      },
      saveDoc: (collection, id, data, {bool merge = false}) async {
        savedCollection = collection;
        savedId = id;
        savedData = data;
      },
    );

    final refDate = DateTime(2026, 11, 26);
    final week = WeeklyActivitySeeder.buildDummyWeek(
      userId: 'u42',
      referenceDate: refDate,
    );
    await repo.saveWeek(week);

    expect(
      savedCollection,
      FirestoreWeeklyActivityRepository.collectionName,
    );
    expect(savedId, 'u42_2026-11-23');
    expect(savedData?['totalDistanceKm'], 37.0);
    expect(savedData?['totalCalories'], 2830);
    expect(savedData?['totalSteps'], 54200);
    final days = savedData?['days'] as List<dynamic>;
    expect(days.length, 7);
    expect((days.first as Map<String, dynamic>)['distanceKm'], 3.2);

    // Simulate offline Firestore read -> falls back to cached week
    failRemote = true;
    final cached = await repo.fetchWeek(userId: 'u42', referenceDate: refDate);
    expect(cached, isNotNull);
    expect(cached!.totalDistanceKm, 37.0);
    expect(cached.totalCalories, 2830);
    expect(cached.totalSteps, 54200);
  });

  testWidgets(
      'StreakChartWidget displays seeded Distance, Calories, and Steps and updates on record',
      (tester) async {
    final repo = MemoryWeeklyActivityRepository();
    final refDate = DateTime(2026, 11, 26);
    final container = ProviderContainer(
      overrides: [
        weeklyActivityRepositoryProvider.overrideWithValue(repo),
        weeklyActivityReferenceDateProvider.overrideWithValue(refDate),
        authStateProvider.overrideWith((ref) => Stream<User?>.value(null)),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: StreakChartWidget(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('37.0 km'), findsOneWidget);
    expect(find.text('7-Day Streak'), findsOneWidget);

    await tester.tap(find.text('Calories'));
    await tester.pumpAndSettle();
    expect(find.text('2830 kcal'), findsOneWidget);

    await tester.tap(find.text('Steps'));
    await tester.pumpAndSettle();
    expect(find.text('54.2k'), findsOneWidget);

    await container.read(weeklyActivityProvider.notifier).addRecordedActivity(
          distanceKm: 3.0,
          calories: 200,
          steps: 4000,
          date: refDate,
        );
    await tester.pumpAndSettle();
    expect(find.text('58.2k'), findsOneWidget);

    await tester.tap(find.text('Distance'));
    await tester.pumpAndSettle();
    expect(find.text('40.0 km'), findsOneWidget);

    await tester.tap(find.text('Calories'));
    await tester.pumpAndSettle();
    expect(find.text('3030 kcal'), findsOneWidget);
  });
}
