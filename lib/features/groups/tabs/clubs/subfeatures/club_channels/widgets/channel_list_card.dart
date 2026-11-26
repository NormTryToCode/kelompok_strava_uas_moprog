import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/channel_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/utils/event_date_format.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class ChannelListCard extends StatelessWidget {
  final ClubChannel channel;
  final VoidCallback onTap;

  const ChannelListCard({
    super.key,
    required this.channel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final last = channel.lastMessage;
    final isAnnouncement = channel.category == ChannelCategory.announcement;
    final iconColor = isAnnouncement ? Styles.accent : Styles.teal;

    return SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      radius: 18,
      child: Row(
        children: [
          IconBubble(channel.category.icon, size: 48, color: iconColor),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        channel.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (channel.postPermission ==
                        ChannelPostPermission.adminsOnly) ...[
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.lock_outline,
                        size: 14,
                        color: Styles.textSecondary,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                _LastMessageRow(lastMessage: last),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (last != null)
                Text(
                  formatClock24(last.sentAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Styles.textSecondary,
                  ),
                ),
              const SizedBox(height: 6),
              if (channel.unreadCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Styles.accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${channel.unreadCount}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                )
              else
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Styles.textSecondary,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LastMessageRow extends StatelessWidget {
  final ChannelMessage? lastMessage;

  const _LastMessageRow({required this.lastMessage});

  @override
  Widget build(BuildContext context) {
    final msg = lastMessage;
    if (msg == null) {
      return const Text(
        'No messages yet',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 13.5, color: Styles.textSecondary),
      );
    }

    return Row(
      children: [
        if (msg.isCurrentUser) ...[
          const Icon(Icons.done_all, size: 15, color: Styles.teal),
          const SizedBox(width: 4),
        ],
        Expanded(
          child: Text(
            msg.isCurrentUser
                ? 'You: ${msg.content}'
                : '${msg.senderName}: ${msg.content}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13.5,
              color: Styles.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

