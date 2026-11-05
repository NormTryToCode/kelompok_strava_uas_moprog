import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../models/trophy_badge.dart';
import '../widgets/trophy_check_box.dart';

class TrophyDetailScreen extends StatefulWidget {
  final TrophyBadge badge;
  final int currentActivities;

  const TrophyDetailScreen({
    super.key,
    required this.badge,
    this.currentActivities = 0,
  });

  @override
  State<TrophyDetailScreen> createState() => _TrophyDetailScreenState();
}

class _TrophyDetailScreenState extends State<TrophyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isUnlocked = widget.badge.isChecked ||
        (widget.currentActivities >= widget.badge.requiredActivities);

    return Animate(
      effects: const [FadeEffect()],
      child: Scaffold(
        backgroundColor: Styles.background,
        appBar: AppBar(
          backgroundColor: Styles.surface,
          title: const Text(
            'Detail Tonggak Pencapaian',
            style: TextStyle(color: Styles.tabActive, fontSize: 18),
          ),
          iconTheme: const IconThemeData(color: Styles.tabActive),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: isUnlocked
                          ? Styles.gradientOrangeBright
                          : const BoxDecoration(color: Styles.surface),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.badge.watermarkNumber,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isUnlocked
                                  ? Styles.background
                                  : Styles.inactive,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Icon(
                            isUnlocked
                                ? Icons.emoji_events
                                : Icons.lock_outline,
                            size: 48,
                            color: isUnlocked
                                ? Styles.background
                                : Styles.tabActive,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.badge.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Styles.tabActive,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isUnlocked
                          ? 'STATUS: TERBUKA (TERCAPAI)'
                          : 'STATUS: TERKUNCI (${widget.currentActivities}/${widget.badge.requiredActivities} Aktivitas)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? Styles.active : Styles.accent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      color: Styles.surface,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            widget.badge.description,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Styles.tabInactive,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Tandai Klaim Trofi Manual: ',
                                style: TextStyle(color: Styles.tabActive),
                              ),
                              TrophyCheckBox(badge: widget.badge),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.badge.toggleIsChecked();
                        });
                      },
                      child: Text(
                        widget.badge.isChecked
                            ? 'Batalkan Klaim Trofi'
                            : 'Simulasi Buka Trofi Ini',
                        style: const TextStyle(color: Styles.accent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}