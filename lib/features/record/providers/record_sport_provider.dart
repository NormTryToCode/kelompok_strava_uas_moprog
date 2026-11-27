import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/record/models/record_sport_catalog.dart';

/// Holds the currently selected sport shared between Record and RecordTrackPage.
class SelectedRecordSportNotifier extends Notifier<RecordSportItem> {
  @override
  RecordSportItem build() => RecordSportCatalog.byName('Run');

  /// Selects [sport] if it differs from the current selection.
  void select(RecordSportItem sport) {
    if (state.id != sport.id) {
      state = sport;
    }
  }

  /// Resolves a sport by [name] from [RecordSportCatalog] and selects it.
  void selectByName(String name) {
    select(RecordSportCatalog.byName(name));
  }
}

final selectedRecordSportProvider =
    NotifierProvider<SelectedRecordSportNotifier, RecordSportItem>(
      SelectedRecordSportNotifier.new,
    );
