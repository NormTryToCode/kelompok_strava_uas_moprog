import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_providers.dart';
import 'package:kelompok_strava_uas_moprog/features/home/data/weekly_activity_repository.dart';
import 'package:kelompok_strava_uas_moprog/features/home/data/weekly_activity_seeder.dart';
import 'package:kelompok_strava_uas_moprog/features/home/models/weekly_activity_model.dart';

final weeklyActivityRepositoryProvider = Provider<WeeklyActivityStore>((ref) {
  return FirestoreWeeklyActivityRepository();
});

final weeklyActivityReferenceDateProvider = Provider<DateTime>((ref) {
  return DateTime.now();
});

/// State container for the current user's weekly activity summary.
class WeeklyActivityState {
  final WeeklyActivityData week;
  final bool isLoading;
  final bool isLoaded;
  final String? errorMessage;

  const WeeklyActivityState({
    required this.week,
    this.isLoading = false,
    this.isLoaded = false,
    this.errorMessage,
  });

  WeeklyActivityState copyWith({
    WeeklyActivityData? week,
    bool? isLoading,
    bool? isLoaded,
    String? errorMessage,
    bool clearError = false,
  }) {
    return WeeklyActivityState(
      week: week ?? this.week,
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Manages loading, seeding, and recording weekly distance, calories, and steps.
class WeeklyActivityNotifier extends Notifier<WeeklyActivityState> {
  static const String fallbackUserId = 'guest_runner';

  int _generation = 0;
  bool _isDisposed = false;

  String _resolveUserId() {
    final uid = ref.read(authStateProvider).valueOrNull?.uid.trim();
    if (uid != null && uid.isNotEmpty) return uid;
    return fallbackUserId;
  }

  @override
  WeeklyActivityState build() {
    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
    });

    final authUser = ref.watch(authStateProvider).valueOrNull;
    final referenceDate = ref.watch(weeklyActivityReferenceDateProvider);
    final rawUid = authUser?.uid.trim() ?? '';
    final userId = rawUid.isNotEmpty ? rawUid : fallbackUserId;
    final generation = ++_generation;

    Future.microtask(
      () => _loadWeek(
        userId: userId,
        referenceDate: referenceDate,
        generation: generation,
      ),
    );

    return WeeklyActivityState(
      week: WeeklyActivityData.empty(
        userId: userId,
        referenceDate: referenceDate,
      ),
      isLoading: true,
      isLoaded: false,
    );
  }

  Future<void> _loadWeek({
    required String userId,
    required DateTime referenceDate,
    required int generation,
  }) async {
    try {
      final week = await WeeklyActivitySeeder.seedCurrentWeekIfMissing(
        userId: userId,
        repository: ref.read(weeklyActivityRepositoryProvider),
        referenceDate: referenceDate,
      );
      if (_isDisposed || generation != _generation) return;
      state = WeeklyActivityState(
        week: week,
        isLoading: false,
        isLoaded: true,
      );
    } catch (e) {
      if (_isDisposed || generation != _generation) return;
      state = WeeklyActivityState(
        week: WeeklyActivitySeeder.buildDummyWeek(
          userId: userId,
          referenceDate: referenceDate,
        ),
        isLoading: false,
        isLoaded: true,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> reload() async {
    final generation = ++_generation;
    state = state.copyWith(isLoading: true, clearError: true);
    await _loadWeek(
      userId: _resolveUserId(),
      referenceDate: ref.read(weeklyActivityReferenceDateProvider),
      generation: generation,
    );
  }

  /// Accumulates recorded activity metrics into the matching weekday in Firestore.
  Future<void> addRecordedActivity({
    double distanceKm = 0,
    int calories = 0,
    int steps = 0,
    DateTime? date,
  }) async {
    final DateTime targetDate =
        date ?? ref.read(weeklyActivityReferenceDateProvider);
    final userId = _resolveUserId();
    final updated = await ref
        .read(weeklyActivityRepositoryProvider)
        .addActivityMetrics(
          userId: userId,
          date: targetDate,
          distanceKm: distanceKm,
          calories: calories,
          steps: steps,
        );
    if (_isDisposed) return;
    state = WeeklyActivityState(
      week: updated,
      isLoading: false,
      isLoaded: true,
    );
  }

  Future<void> reseedCurrentWeek() async {
    final seeded = await WeeklyActivitySeeder.reseedWeek(
      userId: _resolveUserId(),
      repository: ref.read(weeklyActivityRepositoryProvider),
      referenceDate: ref.read(weeklyActivityReferenceDateProvider),
    );
    if (_isDisposed) return;
    state = WeeklyActivityState(
      week: seeded,
      isLoading: false,
      isLoaded: true,
    );
  }
}

final weeklyActivityProvider =
    NotifierProvider<WeeklyActivityNotifier, WeeklyActivityState>(
  WeeklyActivityNotifier.new,
);
