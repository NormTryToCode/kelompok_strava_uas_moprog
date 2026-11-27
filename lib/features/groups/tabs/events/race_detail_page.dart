import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/int_extensions.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/race_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/race_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/services/location_photo_service.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/widgets/race_showcase_card.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/utils/event_date_format.dart';
import 'package:share_plus/share_plus.dart';

class RaceDetailPage extends ConsumerStatefulWidget {
  final Race initialRace;

  const RaceDetailPage({super.key, required this.initialRace});

  static Future<void> open(BuildContext context, Race race) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(builder: (_) => RaceDetailPage(initialRace: race)),
    );
  }

  @override
  ConsumerState<RaceDetailPage> createState() => _RaceDetailPageState();
}

class _RaceDetailPageState extends ConsumerState<RaceDetailPage> {
  late String _selectedTierId;

  @override
  void initState() {
    super.initState();
    _selectedTierId =
        widget.initialRace.selectedTierId ??
        (widget.initialRace.distanceTiers.isNotEmpty
            ? widget.initialRace.distanceTiers.first.id
            : '');
  }

  String _formatPrice(int idr) {
    if (idr <= 0) return 'Free';
    return 'Rp ${idr.withThousands}';
  }

  @override
  Widget build(BuildContext context) {
    final allRaces = ref.watch(racesProvider).valueOrNull ?? const <Race>[];
    final race = allRaces.firstWhere(
      (r) => r.id == widget.initialRace.id,
      orElse: () => widget.initialRace,
    );
    final activeTier = race.distanceTiers.firstWhere(
      (t) => t.id == _selectedTierId,
      orElse: () => race.distanceTiers.first,
    );
    final similarRaces = allRaces.where((r) => r.id != race.id).toList();

    final photoUrl = ref
        .watch(
          locationPhotoProvider(
            LocationPhotoQuery(
              latitude: race.latitude,
              longitude: race.longitude,
              placeName: race.landmarkQuery ?? race.city,
              detail: race.region,
            ),
          ),
        )
        .valueOrNull;

    return Scaffold(
      backgroundColor: Styles.canvas,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 220,
                  pinned: true,
                  backgroundColor: Styles.canvas,
                  foregroundColor: Styles.textPrimary,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      onPressed: () => SharePlus.instance.share(
                        ShareParams(
                          text:
                              '${race.title} (${formatDate(race.startDate)}) in ${race.locationLabel}',
                          subject: race.title,
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: Styles.coverFor(race.id),
                          ),
                        ),
                        if (photoUrl != null)
                          Image.network(
                            photoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const SizedBox.shrink(),
                          ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Styles.canvas.withValues(alpha: 0.45),
                                Colors.transparent,
                                Styles.canvas,
                              ],
                              stops: const [0.0, 0.55, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _BadgeChip(
                            label: formatDate(race.startDate),
                            highlighted: true,
                          ),
                          _BadgeChip(label: race.sport.name),
                          _BadgeChip(label: race.terrain),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        race.title,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Styles.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${race.locationLabel} \u00b7 ${race.registeredCount.withThousands} athletes racing',
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: Styles.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Select Distance',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Styles.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final tier in race.distanceTiers)
                            ChoiceChip(
                              label: Text(tier.label),
                              selected: tier.id == activeTier.id,
                              showCheckmark: false,
                              selectedColor: Styles.surfaceHighlight,
                              backgroundColor: Styles.surface,
                              side: BorderSide(
                                color: tier.id == activeTier.id
                                    ? Styles.primary
                                    : Styles.border,
                              ),
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: tier.id == activeTier.id
                                    ? Styles.textPrimary
                                    : Styles.textSecondary,
                              ),
                              onSelected: (_) =>
                                  setState(() => _selectedTierId = tier.id),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: Styles.cardDecoration(radius: Radii.card),
                        child: Text(
                          race.description,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Styles.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: Styles.cardDecoration(radius: Radii.card),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                _ConditionCell(
                                  label: 'ENTRY FEE',
                                  value: _formatPrice(activeTier.priceIdr),
                                  accent: true,
                                ),
                                _ConditionCell(
                                  label: 'ELEVATION',
                                  value: '+${race.elevationGainMeters} m',
                                ),
                                _ConditionCell(
                                  label: 'PROFILE',
                                  value: race.elevationProfile.name.toUpperCase(),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider(height: 1, color: Styles.divider),
                            ),
                            Row(
                              children: [
                                _ConditionCell(
                                  label: 'TEMPERATURE',
                                  value: '${race.avgTemperatureCelsius}\u00b0C',
                                ),
                                _ConditionCell(
                                  label: 'HUMIDITY',
                                  value: race.humidityLabel,
                                ),
                                _ConditionCell(
                                  label: 'WIND',
                                  value: race.windLabel,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (similarRaces.isNotEmpty) ...[
                        const SizedBox(height: 26),
                        const Text(
                          'More Races Like This',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Styles.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 292,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: similarRaces.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 12),
                            itemBuilder: (_, index) => RaceShowcaseCard(
                              width: 280,
                              race: similarRaces[index],
                              onTap: () => RaceDetailPage.open(
                                context,
                                similarRaces[index],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ]),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: const BoxDecoration(
              color: Styles.canvas,
              border: Border(top: BorderSide(color: Styles.divider)),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: () {
                    ref
                        .read(racesProvider.notifier)
                        .toggleRegistration(race.id, tierId: activeTier.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          race.isRegistered
                              ? 'Registration cancelled for ${race.title}'
                              : 'Registered for ${race.title} (${activeTier.label})',
                        ),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: race.isRegistered
                        ? Styles.surfaceHighlight
                        : Styles.primary,
                    foregroundColor: Styles.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.button),
                      side: race.isRegistered
                          ? const BorderSide(color: Styles.primary)
                          : BorderSide.none,
                    ),
                  ),
                  icon: Icon(
                    race.isRegistered
                        ? Icons.check_circle_outline
                        : Icons.flag_outlined,
                    size: 19,
                  ),
                  label: Text(
                    race.isRegistered
                        ? 'Registered \u00b7 Tap to cancel'
                        : 'Register (${activeTier.label})',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final String label;
  final bool highlighted;

  const _BadgeChip({required this.label, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: highlighted ? Styles.primary : Styles.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlighted ? Styles.primaryLight : Styles.border,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Styles.textPrimary,
        ),
      ),
    );
  }
}

class _ConditionCell extends StatelessWidget {
  final String label;
  final String value;
  final bool accent;

  const _ConditionCell({
    required this.label,
    required this.value,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: Styles.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: accent ? Styles.primaryLight : Styles.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}