import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/location_search_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/models/event_filter_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/utils/event_date_format.dart';

class EventFiltersPage extends StatefulWidget {
  final EventFilter initialFilter;

  const EventFiltersPage({super.key, required this.initialFilter});

  static Future<EventFilter?> open(
    BuildContext context, {
    required EventFilter initialFilter,
  }) {
    return Navigator.of(context, rootNavigator: true).push<EventFilter>(
      MaterialPageRoute<EventFilter>(
        builder: (_) => EventFiltersPage(initialFilter: initialFilter),
      ),
    );
  }

  @override
  State<EventFiltersPage> createState() => _EventFiltersPageState();
}

class _EventFiltersPageState extends State<EventFiltersPage> {
  late EventFilter _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.initialFilter;
  }

  Future<void> _pickCustomDateRange() async {
    final initialStart = _draft.customStart ?? DateTime(2027, 1, 1);
    final initialEnd = _draft.customEnd ?? DateTime(2027, 3, 31);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      initialDateRange: DateTimeRange(start: initialStart, end: initialEnd),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(useMaterial3: true).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Styles.accent,
              onPrimary: Colors.white,
              surface: Styles.surface,
              onSurface: Colors.white,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked == null || !mounted) return;
    setState(() {
      _draft = _draft.copyWith(
        dateFilter: EventDateFilter.custom,
        customStart: picked.start,
        customEnd: picked.end,
      );
    });
  }

  Future<void> _pickCity() async {
    final location = await LocationSearchPage.open(context);
    if (location == null || !mounted) return;

    setState(() {
      _draft = _draft.copyWith(
        locationFilter: EventLocationFilter.city,
        pickedCity: location.name,
      );
    });
  }

  void _toggleDate(EventDateFilter value) {
    if (value == EventDateFilter.custom) {
      _pickCustomDateRange();
      return;
    }
    setState(() {
      if (_draft.dateFilter == value) {
        _draft = _draft.copyWith(clearDate: true);
      } else {
        _draft = _draft.copyWith(dateFilter: value);
      }
    });
  }

  void _toggleLocation(EventLocationFilter value) {
    if (value == EventLocationFilter.city) {
      _pickCity();
      return;
    }
    setState(() {
      if (_draft.locationFilter == value) {
        _draft = _draft.copyWith(clearLocation: true);
      } else {
        _draft = _draft.copyWith(
          locationFilter: value,
          clearPickedCity: true,
        );
      }
    });
  }

  void _toggleFormat(EventKind kind) {
    setState(() {
      if (_draft.format?.id == kind.id) {
        _draft = _draft.copyWith(clearFormat: true);
      } else {
        _draft = _draft.copyWith(format: kind);
      }
    });
  }

  String get _customDateLabel {
    if (_draft.dateFilter == EventDateFilter.custom &&
        _draft.customStart != null &&
        _draft.customEnd != null) {
      final s = _draft.customStart!;
      final e = _draft.customEnd!;
      return '${monthShort(s.month)} ${s.day} - ${monthShort(e.month)} ${e.day}';
    }
    return 'Custom';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.background,
      appBar: AppBar(
        backgroundColor: Styles.background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          'Filters',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                const _SectionHeading('Date'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _FilterOptionChip(
                      label: 'Today',
                      selected: _draft.dateFilter == EventDateFilter.today,
                      onTap: () => _toggleDate(EventDateFilter.today),
                    ),
                    _FilterOptionChip(
                      label: '7 days',
                      selected: _draft.dateFilter == EventDateFilter.days7,
                      onTap: () => _toggleDate(EventDateFilter.days7),
                    ),
                    _FilterOptionChip(
                      label: '30 days',
                      selected: _draft.dateFilter == EventDateFilter.days30,
                      onTap: () => _toggleDate(EventDateFilter.days30),
                    ),
                    _FilterOptionChip(
                      label: _customDateLabel,
                      selected: _draft.dateFilter == EventDateFilter.custom,
                      onTap: () => _toggleDate(EventDateFilter.custom),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const _SectionHeading('Location'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _FilterOptionChip(
                      label: 'Near Me',
                      selected:
                          _draft.locationFilter == EventLocationFilter.nearMe,
                      onTap: () => _toggleLocation(EventLocationFilter.nearMe),
                    ),
                    _FilterOptionChip(
                      label: 'Virtual',
                      selected:
                          _draft.locationFilter == EventLocationFilter.virtual,
                      onTap: () => _toggleLocation(EventLocationFilter.virtual),
                    ),
                    _FilterOptionChip(
                      icon: Icons.search,
                      label: _draft.locationFilter == EventLocationFilter.city &&
                              _draft.pickedCity != null
                          ? _draft.pickedCity!
                          : 'Pick a City',
                      selected:
                          _draft.locationFilter == EventLocationFilter.city,
                      onTap: () => _toggleLocation(EventLocationFilter.city),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const _SectionHeading('Format'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final kind in EventKind.option)
                      _FilterOptionChip(
                        label: kind.name,
                        selected: _draft.format?.id == kind.id,
                        onTap: () => _toggleFormat(kind),
                      ),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    const Expanded(child: _SectionHeading('Event Distance')),
                    if (_draft.hasDistanceFilter)
                      TextButton(
                        onPressed: () => setState(() {
                          _draft = _draft.copyWith(
                            minDistanceKm: 0,
                            maxDistanceKm: EventFilter.maxDistanceLimit,
                          );
                        }),
                        style: TextButton.styleFrom(
                          foregroundColor: Styles.accent,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Styles.accent,
                    inactiveTrackColor: Styles.inactive,
                    thumbColor: Colors.white,
                    overlayColor: Styles.accent.withAlpha(40),
                    trackHeight: 4,
                  ),
                  child: RangeSlider(
                    min: 0,
                    max: EventFilter.maxDistanceLimit,
                    divisions: 32,
                    values: RangeValues(
                      _draft.minDistanceKm,
                      _draft.maxDistanceKm,
                    ),
                    onChanged: (values) {
                      setState(() {
                        _draft = _draft.copyWith(
                          minDistanceKm: values.start,
                          maxDistanceKm: values.end,
                        );
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_draft.minDistanceKm.round()} km',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Styles.tabInactive,
                        ),
                      ),
                      Text(
                        '${_draft.maxDistanceKm.round()} km',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Styles.tabInactive,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Styles.background,
              border: Border(top: BorderSide(color: Palette.cardBorder)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => setState(() {
                            _draft = _draft.resetSecondaryFilters();
                          }),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Styles.tabInactive,
                            side: const BorderSide(color: Palette.cardBorder),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: FilledButton(
                          onPressed: () => Navigator.of(context).pop(_draft),
                          style: FilledButton.styleFrom(
                            backgroundColor: Styles.accent,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String text;

  const _SectionHeading(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16.5,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
    );
  }
}

class _FilterOptionChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const _FilterOptionChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Styles.accent.withAlpha(28) : Styles.surface,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? Styles.accent : Palette.cardBorder,
          width: selected ? 1.4 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: selected ? Styles.accent : Colors.white,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected ? Styles.accent : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}