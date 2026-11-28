import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/date_time_extensions.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_invite_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/invite_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/widgets/notification_tile.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  Future<void> _acceptInvite(
    BuildContext context,
    WidgetRef ref,
    ClubInvite invite,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(myPendingInvitesProvider.notifier).accept(invite);
      final clubLabel =
          invite.clubName.isNotEmpty ? invite.clubName : 'the club';
      ref
          .read(notificationsProvider.notifier)
          .notifyClubJoined(clubName: clubLabel);
      messenger.showSnackBar(
        SnackBar(content: Text('Joined $clubLabel')),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Failed to accept club invite.')),
      );
    }
  }

  Future<void> _declineInvite(
    BuildContext context,
    WidgetRef ref,
    ClubInvite invite,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(myPendingInvitesProvider.notifier).decline(invite);
      messenger.showSnackBar(
        const SnackBar(content: Text('Club invitation declined')),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Failed to decline club invite.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(notificationsProvider);
    final pendingInvites = ref.watch(pendingClubInvitesProvider);
    final unreadNotifications = list.where((item) => !item.isRead).length;
    final notifier = ref.read(notificationsProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppHeader(
        title: 'Notifications',
        showBackButton: true,
        actions: [
          if (unreadNotifications > 0)
            TextButton(
              onPressed: notifier.markAllAsRead,
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: list.isEmpty && pendingInvites.isEmpty
          ? const Center(
              child: Text(
                'No notifications yet',
                style: TextStyle(color: Styles.textSecondary, fontSize: 18),
              ),
            )
          : ListView(
              children: [
                if (pendingInvites.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'CLUB INVITATIONS',
                      style: TextStyle(
                        color: Styles.primaryLight,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  for (final invite in pendingInvites)
                    _ClubInviteCard(
                      invite: invite,
                      onAccept: () => _acceptInvite(context, ref, invite),
                      onDecline: () => _declineInvite(context, ref, invite),
                    ),
                ],
                for (var i = 0; i < list.length; i++)
                  Dismissible(
                    key: ValueKey(list[i].id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      color: Styles.danger,
                      child: const Icon(
                        Icons.delete_outline,
                        color: Styles.textPrimary,
                      ),
                    ),
                    onDismissed: (_) {
                      final removed = list[i];
                      final index = i;
                      notifier.remove(removed.id);
                      messenger
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: const Text('Notification removed'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () => notifier.restore(removed, index),
                            ),
                          ),
                        );
                    },
                    child: NotificationTile(
                      item: list[i],
                      onTap: () => notifier.markAsRead(list[i].id),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _ClubInviteCard extends StatelessWidget {
  final ClubInvite invite;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _ClubInviteCard({
    required this.invite,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final clubName =
        invite.clubName.isNotEmpty ? invite.clubName : 'a Stride club';
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Styles.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Styles.borderStrong),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${invite.invitedByName} invited you to join $clubName',
            style: const TextStyle(
              color: Styles.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            invite.invitedAt.timeAgo(),
            style: const TextStyle(color: Styles.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: onAccept,
                  style: FilledButton.styleFrom(
                    backgroundColor: Styles.primary,
                    foregroundColor: Styles.textPrimary,
                  ),
                  child: const Text('Accept'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onDecline,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Styles.textSecondary,
                    side: const BorderSide(color: Styles.borderStrong),
                  ),
                  child: const Text('Decline'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}