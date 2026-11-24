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
  bool joinedChallenge = false;
  final ProfileUrlService _urlService = ProfileUrlService();

  static const List<_TrophyPreviewItem> _previewItems = [
    _TrophyPreviewItem(
      id: 'm1',
      shortLabel: 'Pertama',
      watermarkNumber: '1',
      requiredActivities: 1,
    ),
    _TrophyPreviewItem(
      id: 'm3',
      shortLabel: 'Ketiga',
      watermarkNumber: '3',
      requiredActivities: 3,
    ),
    _TrophyPreviewItem(
      id: 'm5',
      shortLabel: 'Kelima',
      watermarkNumber: '5',
      requiredActivities: 5,
    ),
    _TrophyPreviewItem(
      id: 'm10',
      shortLabel: 'Ke10',
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
      await _urlService.openUrl('https://www.strava.com/features');
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
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LainnyaMenuTile(
            icon: Icons.bar_chart_rounded,
            title: 'Statistik',
            onTap: widget.onOpenStatistics,
          ),
          const SizedBox(height: 10),
          _LainnyaMenuTile(
            icon: Icons.location_on_outlined,
            title: 'Segmen',
            onTap: widget.onOpenSegments,
          ),
          const SizedBox(height: 10),
          _LainnyaMenuTile(
            icon: Icons.pedal_bike,
            title: 'Perlengkapan',
            onTap: widget.onOpenGearCatalog,
            trailingWidget: activeGearCount == 0
              ? null
              : Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Styles.primary.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Styles.primaryLight),
                    ),
                    child: Text(
                      '$activeGearCount aktif',
                      style: const TextStyle(
                        color: Styles.primaryLight,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
          ),
          const SizedBox(height: 10),
          _LainnyaMenuTile(
            icon: Icons.open_in_new_rounded,
            title: 'Portal Web & Panduan ${AppBrand.name}',
            onTap: _openExternalPortal,
          ),
          const SizedBox(height: 20),
          const Text(
            'Tantangan',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Styles.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            decoration: Styles.cardDecoration(
              radius: Radii.field,
              highlighted: true,
            ),
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ikuti Tantangan untuk menemukan motivasi, membangun kebiasaan, dan mendapatkan hadiah.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Styles.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: joinedChallenge
                        ? Styles.success.withValues(alpha: 0.2)
                        : Styles.primary,
                      foregroundColor: joinedChallenge
                        ? Styles.success
                        : Styles.textPrimary,
                      side: joinedChallenge
                        ? const BorderSide(color: Styles.success)
                        : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Radii.button),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      setState(() {
                        joinedChallenge = !joinedChallenge;
                      });
                    },
                    child: Text(
                      joinedChallenge
                        ? 'Tantangan Diikuti!'
                        : 'Temukan Tantangan Baru',
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                      'Tempat Trofi',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Styles.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$unlockedCount dari ${_previewItems.length} tonggak utama terbuka',
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
                  'Semua trofi >',
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                                  BorderRadius.circular(Radii.chip),
                                boxShadow: Styles.glow(
                                  intensity: 0.25,
                                  blur: 12,
                                ),
                              )
                            : BoxDecoration(
                                color: Styles.surfaceElevated,
                                borderRadius:
                                  BorderRadius.circular(Radii.chip),
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
                                  fontWeight: FontWeight.bold,
                                  color: isUnlocked
                                    ? Styles.canvas
                                    : Styles.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Icon(
                                isUnlocked
                                  ? Icons.emoji_events
                                  : Icons.lock_outline,
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
                              ? FontWeight.bold
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

class _LainnyaMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailingWidget;

  const _LainnyaMenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Styles.surface,
      borderRadius: BorderRadius.circular(Radii.chip),
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.chip),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
            vertical: 14.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radii.chip),
            border: Border.all(color: Styles.borderStrong),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Styles.surfaceHighlight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: Styles.primaryLight, size: 19),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Styles.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ?trailingWidget,
                  const Icon(
                    Icons.chevron_right,
                    color: Styles.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}