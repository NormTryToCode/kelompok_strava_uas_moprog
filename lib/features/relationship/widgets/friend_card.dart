import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/friend.dart';

class FriendCard extends StatelessWidget {
  final Friend friend;
  final VoidCallback onRemove;

  const FriendCard({super.key, required this.friend, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Styles.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Styles.accent,
          child: Text(friend.name[0], style: const TextStyle(color: Colors.white)),
        ),
        title: Text(friend.name, style: const TextStyle(color: Colors.white)),
        subtitle: Text('@${friend.username}', style: const TextStyle(color: Colors.white70)),
        trailing: IconButton(
          icon: const Icon(Icons.person_remove, color: Colors.white70),
          onPressed: onRemove,
        ),
      ),
    );
  }
}