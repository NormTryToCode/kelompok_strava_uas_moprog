import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/int_extensions.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../../shared/utils/profile_page_route.dart';
import '../models/athlete_gear.dart';
import '../providers/athlete_gear_provider.dart';
import '../widgets/gear_detail_sheet.dart';
import 'gear_form_screen.dart';
import 'retired_gear_screen.dart';

class GearManagementView extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const GearManagementView({
    super.key,
    required this.onBack,
  });

  @override
  ConsumerState<GearManagementView> createState() => _GearManagementViewState();
}

class _GearManagementViewState extends ConsumerState<GearManagementView> {
  GearCategory? _selectedFilter;

  void _openAddGearScreen(BuildContext context) {
    Navigator.of(context).push(
      buildProfileRoute(
        GearFormScreen(
          initialCategory: _selectedFilter ?? GearCategory.bike,
        ),
      ),
    );
  }

  void _openDetailSheet(BuildContext context, AthleteGear gear) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Theme(
        data: buildProfileDarkTheme(),
        child: GearDetailSheet(
          gearId: gear.id,
          onEdit: (selectedGear) {
            Navigator.of(context).push(
              buildProfileRoute(GearFormScreen(existingGear: selectedGear)),
            );
          },
        ),
      ),
    );
  }

  void _openRetiredScreen(BuildContext context, GearCategory category) {
    Navigator.of(context).push(
      buildProfileRoute(RetiredGearScreen(category: category)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<AthleteGear> allGear = ref.watch(athleteGearProvider);
    final int activeTotal = allGear.where((g) => !g.isRetired).length;
    final int attentionCount =
      allGear.where((g) => !g.isRetired && g.isReplacementDue).length;
    final double totalTrackedKm = allGear.fold<double>(
      0.0,
      (sum, item) => sum + item.currentDistanceKm,
    );

    final List<GearCategory> visibleCategories = _selectedFilter != null
      ? [_selectedFilter!]
      : GearCategory.values;

    final bool filteredHasItems = visibleCategories.any(
      (cat) => allGear.any((g) => g.category == cat),
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onBack,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Styles.surfaceElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Styles.borderStrong),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Styles.textPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gear Locker',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Styles.textPrimary,
                            ),
                          ),
                          Text(
                            'Equipment Vault & Wear Telemetry',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Styles.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _openAddGearScreen(context),
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    gradient: Styles.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: Styles.glow(intensity: 0.3, blur: 12),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    size: 22,
                    color: Styles.canvas,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Styles.border),
        Expanded(
          child: allGear.isEmpty
            ? _EmptyGearState(
                onAddGear: () => _openAddGearScreen(context),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
                children: [
                  _VaultTelemetryHero(
                    activeCount: activeTotal,
                    totalKm: totalTrackedKm,
                    attentionCount: attentionCount,
                  ),
                  const SizedBox(height: 14),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _CategoryFilterPill(
                          label: 'All ($activeTotal)',
                          icon: Icons.grid_view_rounded,
                          isSelected: _selectedFilter == null,
                          onTap: () {
                            setState(() => _selectedFilter = null);
                          },
                        ),
                        ...GearCategory.values.map((category) {
                          final int count = allGear
                            .where(
                              (g) =>
                                g.category == category && !g.isRetired,
                            )
                            .length;
                          return Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: _CategoryFilterPill(
                              label: '${category.pluralLabel} ($count)',
                              icon: category.icon,
                              isSelected: _selectedFilter == category,
                              onTap: () {
                                setState(() => _selectedFilter = category);
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (!filteredHasItems && _selectedFilter != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 28,
                      ),
                      decoration: Styles.cardDecoration(radius: Radii.card),
                      child: Column(
                        children: [
                          Icon(
                            _selectedFilter!.icon,
                            size: 38,
                            color: Styles.primaryLight,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'No ${_selectedFilter!.pluralLabel} Registered',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Styles.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Register your ${_selectedFilter!.label.toLowerCase()} to track mileage and wear-life.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Styles.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ...visibleCategories.map((category) {
                    final activeInCat = allGear
                      .where(
                        (g) => g.category == category && !g.isRetired,
                      )
                      .toList();
                    final retiredInCat = allGear
                      .where(
                        (g) => g.category == category && g.isRetired,
                      )
                      .toList();

                    if (activeInCat.isEmpty && retiredInCat.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      gradient: Styles.primaryGradient,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    category.icon,
                                    size: 16,
                                    color: Styles.primaryLight,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    category.sectionHeader,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.0,
                                      color: Styles.primaryLight,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Styles.surfaceElevated,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Styles.borderStrong,
                                  ),
                                ),
                                child: Text(
                                  '${activeInCat.length} active',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Styles.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...activeInCat.map(
                            (gear) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _GearVaultCard(
                                gear: gear,
                                onTap: () => _openDetailSheet(context, gear),
                              ),
                            ),
                          ),
                          if (retiredInCat.isNotEmpty)
                            Material(
                              color: Styles.surfaceElevated,
                              borderRadius:
                                BorderRadius.circular(Radii.field),
                              child: InkWell(
                                borderRadius:
                                  BorderRadius.circular(Radii.field),
                                onTap: () =>
                                  _openRetiredScreen(context, category),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 13,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                      BorderRadius.circular(Radii.field),
                                    border: Border.all(
                                      color: Styles.borderStrong,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.inventory_2_outlined,
                                            size: 18,
                                            color: Styles.textSecondary,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            '${category.retiredLabel} Archive',
                                            style: const TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w600,
                                              color: Styles.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Styles.surfaceHighlight,
                                              borderRadius:
                                                BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '${retiredInCat.length}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w800,
                                                color: Styles.primaryLight,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.chevron_right_rounded,
                                            color: Styles.textSecondary,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: Styles.buttonDecoration(
                        radius: Radii.button,
                        withGlow: true,
                      ),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Styles.canvas,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Radii.button),
                          ),
                        ),
                        onPressed: () => _openAddGearScreen(context),
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        label: const Text(
                          'Register New Equipment',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        ),
      ],
    );
  }
}

class _VaultTelemetryHero extends StatelessWidget {
  final int activeCount;
  final double totalKm;
  final int attentionCount;

  const _VaultTelemetryHero({
    required this.activeCount,
    required this.totalKm,
    required this.attentionCount,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasAlert = attentionCount > 0;

    return Container(
      decoration: Styles.cardDecoration(
        radius: Radii.card,
        highlighted: true,
        withGlow: true,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: -55,
            right: -45,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                gradient: Styles.radialGlow(
                  color: hasAlert ? Styles.danger : Styles.primary,
                  intensity: 0.28,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'EQUIPMENT VAULT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                        color: Styles.primaryLight,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: (hasAlert ? Styles.danger : Styles.success)
                          .withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: hasAlert ? Styles.danger : Styles.success,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            hasAlert
                              ? Icons.warning_amber_rounded
                              : Icons.verified_rounded,
                            size: 13,
                            color: hasAlert ? Styles.danger : Styles.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hasAlert
                              ? '$attentionCount Replace Due'
                              : 'All Optimal',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: hasAlert ? Styles.danger : Styles.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Styles.canvas.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(Radii.field),
                          border: Border.all(color: Styles.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Active Units',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Styles.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '$activeCount ${activeCount == 1 ? 'item' : 'items'}',
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                                color: Styles.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Styles.canvas.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(Radii.field),
                          border: Border.all(color: Styles.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tracked Mileage',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Styles.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${totalKm.round().withThousands} km',
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                                color: Styles.primaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilterPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryFilterPill({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? Styles.primaryGradient : null,
          color: isSelected ? null : Styles.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Styles.primaryLight : Styles.borderStrong,
          ),
          boxShadow: isSelected ? Styles.glow(intensity: 0.25, blur: 10) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? Styles.canvas : Styles.primaryLight,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: isSelected ? Styles.canvas : Styles.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyGearState extends StatelessWidget {
  final VoidCallback onAddGear;

  const _EmptyGearState({required this.onAddGear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Styles.surfaceElevated,
                shape: BoxShape.circle,
                border: Border.all(color: Styles.primary.withValues(alpha: 0.5)),
                boxShadow: Styles.glow(intensity: 0.3, blur: 24),
              ),
              child: const Icon(
                Icons.pedal_bike_rounded,
                size: 46,
                color: Styles.primaryLight,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Your Gear Locker is Ready',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Styles.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Register bikes, running shoes, wearables, or swim kit to track mileage and wear-life alerts.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: Styles.textSecondary,
              ),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: Styles.buttonDecoration(
                  radius: Radii.button,
                  withGlow: true,
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Styles.canvas,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.button),
                    ),
                  ),
                  onPressed: onAddGear,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text(
                    'Add First Equipment',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GearVaultCard extends StatelessWidget {
  final AthleteGear gear;
  final VoidCallback onTap;

  const _GearVaultCard({
    required this.gear,
    required this.onTap,
  });

  Color get _healthColor {
    if (gear.isReplacementDue) return Styles.danger;
    if (gear.isHighWear) return Styles.warning;
    return Styles.primaryLight;
  }

  List<Color> get _barGradientColors {
    if (gear.isReplacementDue) {
      return const [Styles.danger, Color(0xFFFF9EB0)];
    }
    if (gear.isHighWear) {
      return const [Styles.warning, Color(0xFFFDE68A)];
    }
    return const [Styles.primary, Styles.primaryLight];
  }

  @override
  Widget build(BuildContext context) {
    final double? wearRatio = gear.wearProgressRatio;

    return Material(
      color: Styles.surface,
      borderRadius: BorderRadius.circular(Radii.card),
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.card),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radii.card),
            border: Border.all(
              color: gear.isReplacementDue
                ? Styles.danger.withValues(alpha: 0.6)
                : Styles.borderStrong,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Styles.surfaceHighlight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Styles.primary.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Icon(
                      gear.category.icon,
                      size: 20,
                      color: Styles.primaryLight,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gear.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Styles.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          gear.brandModelSubtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Styles.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        gear.formattedDistance,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Styles.primaryLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        gear.wearStatusLabel.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                          color: gear.isReplacementDue
                            ? Styles.danger
                            : gear.isHighWear
                              ? Styles.warning
                              : Styles.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (wearRatio != null) ...[
                const SizedBox(height: 14),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double filledWidth =
                        (constraints.maxWidth * wearRatio).clamp(
                      wearRatio > 0 ? 10.0 : 0.0,
                      constraints.maxWidth,
                    );
                    return Container(
                      width: constraints.maxWidth,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Styles.canvas,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: filledWidth,
                        height: 7,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: _barGradientColors),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: Styles.glow(
                            color: _healthColor,
                            intensity: 0.35,
                            blur: 8,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Wear-Life: ${(wearRatio * 100).round()}% of ${gear.maxDistanceKm} km',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: gear.isReplacementDue
                          ? Styles.danger
                          : Styles.textSecondary,
                      ),
                    ),
                    Text(
                      gear.isReplacementDue
                        ? 'Limit Reached'
                        : '${gear.remainingDistanceKm!.round()} km left',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: _healthColor,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (gear.displaySubType.isNotEmpty)
                      _MetaTag(text: gear.displaySubType),
                    if (gear.category == GearCategory.bike &&
                        gear.weightKg != null)
                      _MetaTag(
                        text: '${gear.weightKg!.toStringAsFixed(1)} kg',
                      ),
                    if (gear.category == GearCategory.wearable &&
                        gear.batteryHours != null)
                      _MetaTag(text: '${gear.batteryHours}h battery'),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaTag extends StatelessWidget {
  final String text;

  const _MetaTag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Styles.canvas.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Styles.border),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Styles.textSecondary,
        ),
      ),
    );
  }
}