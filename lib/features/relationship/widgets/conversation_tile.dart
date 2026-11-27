import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ConversationTile extends StatelessWidget {
  final String name;
  final String preview;
  final String time;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.name,
    required this.preview,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Styles.accent,
        child: Text(
          name.isNotEmpty ? name[0] : '?',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(name, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        preview,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white70),
      ),
      trailing: Text(
        time,
        style: const TextStyle(color: Colors.white54, fontSize: 12),
      ),
    );
  }
}