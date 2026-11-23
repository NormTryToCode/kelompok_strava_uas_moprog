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
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LainnyaMenuTile(
            icon: Icons.list_alt,
            title: 'Statistik',
            onTap: widget.onOpenStatistics,
          ),
          const SizedBox(height: 8),
          _LainnyaMenuTile(
            icon: Icons.location_on_outlined,
            title: 'Segmen',
            onTap: widget.onOpenSegments,
          ),
          const SizedBox(height: 8),
          _LainnyaMenuTile(
            icon: Icons.pedal_bike,
            title: 'Perlengkapan',
            onTap: widget.onOpenGearCatalog,
            trailingWidget: activeGearCount == 0
              ? null
              : Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Badge(
                    backgroundColor: Styles.accent,
                    label: Text(
                      '$activeGearCount aktif',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
          ),
          const SizedBox(height: 8),
          _LainnyaMenuTile(
            icon: Icons.open_in_new,
            title: 'Portal Web & Panduan ${AppBrand.name}',
            onTap: _openExternalPortal,
          ),
          const SizedBox(height: 16),
          const Text(
            "Tantangan",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Styles.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Styles.surface,
              borderRadius: BorderRadius.circular(Radii.chip),
              border: Border.all(color: Styles.cardBorder),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ikuti Tantangan untuk menemukan motivasi, membangun kebiasaan, dan mendapatkan hadiah.",
                  style: TextStyle(fontSize: 12, color: Styles.textSecondary),
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        joinedChallenge = !joinedChallenge;
                      });
                    },
                    child: Text(
                      joinedChallenge
                        ? "Tantangan Diikuti!"
                        : "Temukan Tantangan baru",
                      style: const TextStyle(color: Styles.accent),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tempat Trofi",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Styles.textPrimary,
                    ),
                  ),
                  Text(
                    "$unlockedCount dari ${_previewItems.length} tonggak utama terbuka",
                    style: TextStyle(
                      fontSize: 12,
                      color: unlockedCount > 0
                        ? Styles.success
                        : Styles.textSecondary,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: widget.onOpenTrophyCase,
                child: const Text(
                  "Semua trofi >",
                  style: TextStyle(color: Styles.accent),
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
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          decoration: isUnlocked
                            ? BoxDecoration(
                                gradient: Styles.primaryGradient,
                                borderRadius:
                                  BorderRadius.circular(Radii.chip),
                              )
                            : BoxDecoration(
                                color: Styles.surface,
                                borderRadius:
                                  BorderRadius.circular(Radii.chip),
                                border: Border.all(
                                  color: Styles.cardBorder,
                                ),
                              ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.watermarkNumber,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isUnlocked
                                    ? Styles.canvas
                                    : Styles.textMuted,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Icon(
                                isUnlocked
                                  ? Icons.emoji_events
                                  : Icons.lock_outline,
                                size: 22,
                                color: isUnlocked
                                  ? Styles.canvas
                                  : Styles.textPrimary,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.shortLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isUnlocked
                              ? FontWeight.bold
                              : FontWeight.normal,
                            color: isUnlocked
                              ? Styles.accent
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
            border: Border.all(color: Styles.cardBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: Styles.textPrimary),
                  const SizedBox(width: 14),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Styles.textPrimary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  trailingWidget!,
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