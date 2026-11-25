import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/app_brand.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../../gear/providers/athlete_gear_provider.dart';
import '../../shared/services/profile_url_service.dart';
import '../../shared/utils/profile_snackbar_helper.dart';
import '../../trophies/providers/trophy_provider.dart';
import '../providers/profile_activity_provider.dart';

class _TrophyPreviewItem {
  final String id;
  final String shortLabel;
  final String watermarkNumber;
  final int requiredActivities;

  const _TrophyPreviewItem({
    required this.id,
    required this.shortLabel,
    required this.watermarkNumber,
    required this.requiredActivities,
  });
}

class LainnyaTab extends ConsumerStatefulWidget {
  final VoidCallback onOpenTrophyCase;
  final VoidCallback onOpenGearCatalog;
  final VoidCallback onOpenSegments;
  final VoidCallback onOpenStatistics;

  const LainnyaTab({
    super.key,
    required this.onOpenTrophyCase,
    required this.onOpenGearCatalog,
    required this.onOpenSegments,
    required this.onOpenStatistics,
  });

  @override
  ConsumerState<LainnyaTab> createState() => _LainnyaTabState();
}

class _LainnyaTabState extends ConsumerState<LainnyaTab> {
  bool joinedQuest = false;
  final ProfileUrlService _urlService = ProfileUrlService();

  static const List<_TrophyPreviewItem> _previewItems = [
    _TrophyPreviewItem(
      id: 'm1',
      shortLabel: 'First',
      watermarkNumber: '1',
      requiredActivities: 1,
    ),
    _TrophyPreviewItem(
      id: 'm3',
      shortLabel: 'Triple',
      watermarkNumber: '3',
      requiredActivities: 3,
    ),
    _TrophyPreviewItem(
      id: 'm5',
      shortLabel: 'Five',
      watermarkNumber: '5',
      requiredActivities: 5,
    ),
    _TrophyPreviewItem(
      id: 'm10',
      shortLabel: 'Ten',
      watermarkNumber: '10',
      requiredActivities: 10,
    ),
  ];

  bool _isPreviewUnlocked(
    _TrophyPreviewItem item,
    int currentActivities,
    Set<String> claimedTrophyIds,
  ) {
    return currentActivities >= item.requiredActivities ||
      claimedTrophyIds.contains(item.id);
  }

  Future<void> _openExternalPortal() async {
    try {
      await _urlService.openUrl('https://worldathletics.org');
    } catch (e) {
      if (!mounted) return;
      ProfileSnackbarHelper.showError(context, '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final int currentActivities = ref.watch(runSessionsProvider);
    final Set<String> claimedTrophyIds = ref.watch(claimedTrophiesProvider);
    final int activeGearCount = ref.watch(activeGearCountProvider);

    final int unlockedCount = _previewItems
      .where(
        (item) =>
          _isPreviewUnlocked(item, currentActivities, claimedTrophyIds),
      )
      .length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ATHLETE TOOLKIT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
              color: Styles.primaryLight,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _VaultBentoTile(
                  icon: Icons.insights_rounded,
                  title: 'Performance Lab',
                  subtitle: 'Multi-sport analytics',
                  onTap: widget.onOpenStatistics,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _VaultBentoTile(
                  icon: Icons.radar_rounded,
                  title: 'GPS Radar',
                  subtitle: 'Live trail locator',
                  onTap: widget.onOpenSegments,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _VaultBentoTile(
                  icon: Icons.pedal_bike_rounded,
                  title: 'Gear Locker',
                  subtitle: 'Track equipment life',
                  badgeText: activeGearCount > 0
                    ? '$activeGearCount active'
                    : null,
                  onTap: widget.onOpenGearCatalog,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _VaultBentoTile(
                  icon: Icons.public_rounded,
                  title: '${AppBrand.name} Web',
                  subtitle: 'Global athletics hub',
                  onTap: _openExternalPortal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            decoration: Styles.cardDecoration(
              radius: Radii.card,
              highlighted: true,
              withGlow: true,
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Styles.canvas.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Styles.primary.withValues(alpha: 0.5),
                        ),
                      ),
                      child: const Icon(
                        Icons.local_fire_department_rounded,
                        color: Styles.primaryLight,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'November Velocity Quest',
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w800,
                              color: Styles.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Stay consistent this month to earn an exclusive crest.',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Styles.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: joinedQuest
                        ? Styles.success.withValues(alpha: 0.18)
                        : Styles.primary,
                      foregroundColor:
                        joinedQuest ? Styles.success : Styles.textPrimary,
                      side: joinedQuest
                        ? const BorderSide(color: Styles.success)
                        : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Radii.button),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      setState(() {
                        joinedQuest = !joinedQuest;
                      });
                    },
                    child: Text(
                      joinedQuest ? 'Quest Active ✓' : 'Join Monthly Quest',
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trophy Vault',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Styles.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$unlockedCount of ${_previewItems.length} core crests unlocked',
                      style: TextStyle(
                        fontSize: 13,
                        color: unlockedCount > 0
                          ? Styles.success
                          : Styles.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: widget.onOpenTrophyCase,
                style: TextButton.styleFrom(
                  foregroundColor: Styles.primaryLight,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                child: const Text(
                  'Open Vault >',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _previewItems.map((item) {
              final bool isUnlocked = _isPreviewUnlocked(
                item,
                currentActivities,
                claimedTrophyIds,
              );
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: widget.onOpenTrophyCase,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: isUnlocked
                            ? BoxDecoration(
                                gradient: Styles.primaryGradient,
                                borderRadius:
                                  BorderRadius.circular(Radii.field),
                                boxShadow: Styles.glow(
                                  intensity: 0.28,
                                  blur: 12,
                                ),
                              )
                            : BoxDecoration(
                                color: Styles.surfaceElevated,
                                borderRadius:
                                  BorderRadius.circular(Radii.field),
                                border: Border.all(
                                  color: Styles.borderStrong,
                                ),
                              ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.watermarkNumber,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: isUnlocked
                                    ? Styles.canvas
                                    : Styles.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Icon(
                                isUnlocked
                                  ? Icons.emoji_events_rounded
                                  : Icons.lock_outline_rounded,
                                size: 22,
                                color: isUnlocked
                                  ? Styles.canvas
                                  : Styles.primaryLight,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.shortLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isUnlocked
                              ? FontWeight.w700
                              : FontWeight.w500,
                            color: isUnlocked
                              ? Styles.primaryLight
                              : Styles.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _VaultBentoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badgeText;
  final VoidCallback onTap;

  const _VaultBentoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.badgeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Styles.surface,
      borderRadius: BorderRadius.circular(Radii.card),
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.card),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radii.card),
            border: Border.all(color: Styles.borderStrong),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Styles.surfaceHighlight,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(icon, color: Styles.primaryLight, size: 20),
                  ),
                  if (badgeText != null)
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Styles.primary.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Styles.primaryLight),
                        ),
                        child: Text(
                          badgeText!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Styles.primaryLight,
                          ),
                        ),
                      ),
                    )
                  else
                    const Icon(
                      Icons.arrow_outward_rounded,
                      size: 16,
                      color: Styles.textSecondary,
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Styles.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Styles.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}