import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class LainnyaTab extends StatefulWidget {
  final VoidCallback onOpenTrophyCase;

  const LainnyaTab({
    super.key,
    required this.onOpenTrophyCase,
  });

  @override
  State<LainnyaTab> createState() => _LainnyaTabState();
}

class _LainnyaTabState extends State<LainnyaTab> {
  bool joinedChallenge = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.list_alt, color: Styles.tabActive),
                  SizedBox(width: 14),
                  Text(
                    "Statistik",
                    style: TextStyle(fontSize: 15, color: Styles.tabActive),
                  ),
                ],
              ),
              Icon(Icons.chevron_right, color: Styles.tabInactive),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Styles.tabActive),
                  SizedBox(width: 14),
                  Text(
                    "Segmen",
                    style: TextStyle(fontSize: 15, color: Styles.tabActive),
                  ),
                ],
              ),
              Icon(Icons.chevron_right, color: Styles.tabInactive),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.pedal_bike, color: Styles.tabActive),
                  SizedBox(width: 14),
                  Text(
                    "Perlengkapan",
                    style: TextStyle(fontSize: 15, color: Styles.tabActive),
                  ),
                ],
              ),
              Icon(Icons.chevron_right, color: Styles.tabInactive),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Tantangan",
            style: TextStyle(fontSize: 17, color: Styles.tabActive),
          ),
          const SizedBox(height: 6),
          Container(
            color: Styles.surface,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ikuti Tantangan untuk menemukan motivasi, membangun kebiasaan, dan mendapatkan hadiah.",
                  style: TextStyle(fontSize: 12, color: Styles.tabInactive),
                ),
                const SizedBox(height: 8),
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tempat Trofi",
                style: TextStyle(fontSize: 17, color: Styles.tabActive),
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
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Container(
                    color: Styles.surface,
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(Icons.lock_outline, color: Styles.tabActive),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Pertama",
                    style: TextStyle(fontSize: 11, color: Styles.tabInactive),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    color: Styles.surface,
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(Icons.lock_outline, color: Styles.tabActive),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Ketiga",
                    style: TextStyle(fontSize: 11, color: Styles.tabInactive),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    color: Styles.surface,
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(Icons.lock_outline, color: Styles.tabActive),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Kelima",
                    style: TextStyle(fontSize: 11, color: Styles.tabInactive),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    color: Styles.surface,
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(Icons.lock_outline, color: Styles.tabActive),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Ke10",
                    style: TextStyle(fontSize: 11, color: Styles.tabInactive),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}