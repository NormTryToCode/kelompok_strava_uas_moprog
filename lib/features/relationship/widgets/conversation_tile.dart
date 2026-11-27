import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ConversationTile extends StatelessWidget {
  final String name;
  final String preview;
  final String time;
  final VoidCallback onTap;
  final bool unread;

  const ConversationTile({
    super.key,
    required this.name,
    required this.preview,
    required this.time,
    required this.onTap,
    this.unread = false,
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
      title: Text(
        name,
        style: TextStyle(
          color: Colors.white,
          fontWeight: unread ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
      subtitle: Text(
        preview,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: unread ? Colors.white : Colors.white70,
          fontWeight: unread ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          if (unread) ...[
            const SizedBox(height: 4),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Styles.accent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}