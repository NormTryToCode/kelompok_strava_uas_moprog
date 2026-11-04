import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class WeeklyRunCounter extends StatelessWidget {
  final int runSessions;
  final VoidCallback onDecrement;
  final VoidCallback onReset;
  final VoidCallback? onIncrement;

  const WeeklyRunCounter({
    super.key,
    required this.runSessions,
    required this.onDecrement,
    required this.onReset,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final int distanceKm = runSessions * 3;
    final int durationMinutes = runSessions * 20;
    final int elevationMeters = runSessions * 12;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        color: Styles.surface,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Minggu ini",
                  style: TextStyle(
                    fontSize: 18,
                    color: Styles.tabActive,
                  ),
                ),
                Row(
                  children: [
                    IconButton.filled(
                      onPressed: onDecrement,
                      icon: const Icon(Icons.remove, size: 16),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filled(
                      onPressed: onReset,
                      icon: const Icon(Icons.exposure_zero, size: 16),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filled(
                      onPressed: onIncrement,
                      icon: const Icon(Icons.add, size: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Jarak",
                      style: TextStyle(fontSize: 12, color: Styles.tabInactive),
                    ),
                    Text(
                      "$distanceKm km",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Styles.tabActive,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 28),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Waktu",
                      style: TextStyle(fontSize: 12, color: Styles.tabInactive),
                    ),
                    Text(
                      "${durationMinutes}m",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Styles.tabActive,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 28),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Kenaikan Elev",
                      style: TextStyle(fontSize: 12, color: Styles.tabInactive),
                    ),
                    Text(
                      "$elevationMeters m",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Styles.tabActive,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "12 Minggu Terakhir",
              style: TextStyle(fontSize: 12, color: Styles.tabInactive),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 260,
                      height: 1,
                      color: Styles.inactive,
                    ),
                    const SizedBox(height: 22),
                    Container(
                      width: 260,
                      height: 1,
                      color: Styles.inactive,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        ...List.generate(11, (index) {
                          return const Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Icon(
                              Icons.circle_outlined,
                              size: 10,
                              color: Styles.accent,
                            ),
                          );
                        }),
                        const Icon(
                          Icons.circle,
                          size: 14,
                          color: Styles.accent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        SizedBox(width: 36),
                        Text(
                          "SEP",
                          style: TextStyle(
                            fontSize: 11,
                            color: Styles.tabInactive,
                          ),
                        ),
                        SizedBox(width: 72),
                        Text(
                          "OKT",
                          style: TextStyle(
                            fontSize: 11,
                            color: Styles.tabInactive,
                          ),
                        ),
                        SizedBox(width: 72),
                        Text(
                          "NOV",
                          style: TextStyle(
                            fontSize: 11,
                            color: Styles.tabActive,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "6 km",
                      style: TextStyle(fontSize: 11, color: Styles.tabInactive),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "3 km",
                      style: TextStyle(fontSize: 11, color: Styles.tabInactive),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "$distanceKm km",
                      style: const TextStyle(
                        fontSize: 11,
                        color: Styles.accent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (runSessions >= 10)
              const Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  "Target Maksimal (10 Sesi) Minggu Ini Tercapai!",
                  style: TextStyle(fontSize: 12, color: Styles.active),
                ),
              ),
          ],
        ),
      ),
    );
  }
}