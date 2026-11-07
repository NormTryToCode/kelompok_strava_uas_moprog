import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/widgets/notification_tile.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';

class NotificationsPage extends StatelessWidget {
  final NotificationController? controller;

  const NotificationsPage({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    final source = controller ?? NotificationController.instance;
    return ListenableBuilder(
      listenable: source,
      builder: (context, _) {
        final list = source.items;
        return Scaffold(
          backgroundColor: Styles.background,
          appBar: const AppHeader(
            title: 'Notifications',
            showBackButton: true,
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
                  itemBuilder: (_, i) => NotificationTile(item: list[i]),
                ),
        );
      },
    );
  }
}