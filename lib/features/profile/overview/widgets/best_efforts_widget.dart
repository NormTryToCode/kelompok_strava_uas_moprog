import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class BestEffortsWidget extends StatelessWidget {
  final int viewMode;
  final int runSessions;
  final VoidCallback onOpenFeedback;

  const BestEffortsWidget({
    super.key,
    required this.viewMode,
    required this.runSessions,
    required this.onOpenFeedback,
  });

  @override
  Widget build(BuildContext context) {
    if (viewMode == 1) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Styles.surface,
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Usaha Terbaik",
                    style: TextStyle(fontSize: 15, color: Styles.tabActive),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: Styles.gradientOrangeBright,
                            padding: const EdgeInsets.all(6.0),
                            child: const Icon(
                              Icons.workspace_premium,
                              color: Styles.background,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "RP 5K",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Styles.tabActive,
                                ),
                              ),
                              Text(
                                "Nov 3, 2026",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Styles.tabInactive,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Text(
                        "26:54",
                        style: TextStyle(fontSize: 15, color: Styles.tabActive),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            color: Styles.inactive,
                            padding: const EdgeInsets.all(6.0),
                            child: const Icon(
                              Icons.military_tech,
                              color: Styles.tabInactive,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Waktu 5K tercepat ke-2",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Styles.tabInactive,
                                ),
                              ),
                              Text(
                                "Nov 3, 2025",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Styles.tabInactive,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Text(
                        "30:12",
                        style: TextStyle(
                          fontSize: 15,
                          color: Styles.tabInactive,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 170,
                  color: Styles.surface,
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Target",
                        style: TextStyle(fontSize: 14, color: Styles.tabActive),
                      ),
                      const SizedBox(height: 6),
                      const Icon(
                        Icons.directions_run,
                        color: Styles.active,
                        size: 28,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Target Berlari Mingguan",
                        style: TextStyle(
                          fontSize: 12,
                          color: Styles.tabInactive,
                        ),
                      ),
                      Text(
                        "$runSessions/4 lari",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Styles.active,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 170,
                  color: Styles.surface,
                  padding: const EdgeInsets.all(10.0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Usaha Relatif",
                        style: TextStyle(fontSize: 14, color: Styles.tabActive),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "89",
                        style: TextStyle(fontSize: 18, color: Styles.accent),
                      ),
                      Text(
                        "Nov 2 - Nov 8, 2026",
                        style: TextStyle(
                          fontSize: 11,
                          color: Styles.tabInactive,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "22",
                        style: TextStyle(fontSize: 16, color: Styles.badge),
                      ),
                      Text(
                        "Okt 26 - Nov 1, 2026",
                        style: TextStyle(
                          fontSize: 11,
                          color: Styles.tabInactive,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Styles.surface,
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Catatan Latihan",
                  style: TextStyle(fontSize: 15, color: Styles.tabActive),
                ),
                const SizedBox(height: 6),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Nov 2 - Nov 8, 2026",
                      style: TextStyle(fontSize: 13, color: Styles.tabActive),
                    ),
                    Text(
                      "10,9 km",
                      style: TextStyle(fontSize: 13, color: Styles.tabActive),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("S", style: TextStyle(color: Styles.tabInactive)),
                    Text("S", style: TextStyle(color: Styles.tabInactive)),
                    Text("R", style: TextStyle(color: Styles.tabInactive)),
                    Text("K", style: TextStyle(color: Styles.tabInactive)),
                    Text("J", style: TextStyle(color: Styles.tabInactive)),
                    Text("S", style: TextStyle(color: Styles.tabInactive)),
                    Text("M", style: TextStyle(color: Styles.tabInactive)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 20),
                    const Icon(Icons.circle, size: 12, color: Styles.active),
                    const SizedBox(width: 20),
                    Container(
                      color: Styles.active,
                      padding: const EdgeInsets.all(6.0),
                      child: const Text(
                        "3,7 km",
                        style: TextStyle(
                          fontSize: 11,
                          color: Styles.background,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      color: Styles.active,
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        "6,4 km",
                        style: TextStyle(
                          fontSize: 11,
                          color: Styles.background,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 360,
            color: Styles.accent,
            padding: const EdgeInsets.all(10.0),
            child: const Center(
              child: Text(
                "Mulai Percobaan Gratis",
                style: TextStyle(fontSize: 14, color: Styles.tabActive),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tertarik berbagi masukan Anda?",
                style: TextStyle(fontSize: 13, color: Styles.tabActive),
              ),
              ElevatedButton(
                onPressed: onOpenFeedback,
                child: const Text(
                  "Beri Masukan",
                  style: TextStyle(color: Styles.accent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}