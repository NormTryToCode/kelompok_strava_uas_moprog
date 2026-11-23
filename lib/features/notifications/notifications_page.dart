import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/widgets/notification_tile.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(notificationsProvider);
    final unread = ref.watch(unreadCountProvider);
    final notifier = ref.read(notificationsProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);

    return Scaffold(
      backgroundColor: Styles.background,
      appBar: AppHeader(
        title: 'Notifications',
        showBackButton: true,
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: notifier.markAllAsRead,
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: list.isEmpty
          ? const Center(
              child: Text(
                'No notifications yet',
                style: TextStyle(color: Styles.tabActive, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, i) {
                final item = list[i];
                return Dismissible(
                  key: ValueKey(item.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    color: Styles.accent,
                    child: const Icon(
                      Icons.delete_outline,
                      color: Styles.tabActive,
                    ),
                  ),
                  onDismissed: (_) {
                    notifier.remove(item.id);
                    messenger
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: const Text('Notification removed'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () => notifier.restore(item, i),
                          ),
                        ),
                      );
                  },
                  child: NotificationTile(
                    item: item,
                    onTap: () => notifier.markAsRead(item.id),
                  ),
                );
              },
            ),
    );
  }
}