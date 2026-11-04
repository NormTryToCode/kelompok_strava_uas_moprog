import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';

class SportOptionTile extends StatelessWidget {
  final ClubSport sport;
  final bool selected;
  final VoidCallback onTap;

  const SportOptionTile({
    super.key,
    required this.sport,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(sport.icon, size: 32, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sport.name,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  if (sport.subsports != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        sport.subsports!,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.3,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
