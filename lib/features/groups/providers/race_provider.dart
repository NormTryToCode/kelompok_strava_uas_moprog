import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/data/dummy_races.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/race_model.dart';

class RacesNotifier extends Notifier<List<Race>> {
  @override
  List<Race> build() => buildDummyRaces();

  void toggleRegistration(String raceId, {String? tierId}) {
    state = [
      for (final race in state)
        if (race.id == raceId)
          race.isRegistered
              ? race.copyWith(
                  isRegistered: false,
                  clearSelectedTier: true,
                  registeredCount: race.registeredCount > 0
                      ? race.registeredCount - 1
                      : 0,
                )
              : race.copyWith(
                  isRegistered: true,
                  selectedTierId:
                      tierId ??
                      (race.distanceTiers.isNotEmpty
                          ? race.distanceTiers.first.id
                          : null),
                  registeredCount: race.registeredCount + 1,
                )
        else
          race,
    ];
  }
}

final racesProvider = NotifierProvider<RacesNotifier, List<Race>>(
  RacesNotifier.new,
);