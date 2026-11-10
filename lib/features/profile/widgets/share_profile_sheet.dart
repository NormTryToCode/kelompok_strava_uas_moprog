import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class _ShareAppOption {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _ShareAppOption({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    this.iconColor = Colors.white,
  });
}

class ShareProfileBottomSheet extends StatelessWidget {
  final String athleteName;
  final ValueChanged<String> onAppSelected;

  const ShareProfileBottomSheet({
    super.key,
    required this.athleteName,
    required this.onAppSelected,
  });

  static const List<_ShareAppOption> _shareOptions = [
    _ShareAppOption(
      label: 'Strava',
      icon: Icons.directions_run,
      backgroundColor: Styles.accent,
    ),
    _ShareAppOption(
      label: 'Pesan',
      icon: Icons.send,
      backgroundColor: Styles.accent,
    ),
    _ShareAppOption(
      label: 'Salin Tautan',
      icon: Icons.link,
      backgroundColor: Styles.inactive,
    ),
    _ShareAppOption(
      label: 'Messages',
      icon: Icons.camera_alt_outlined,
      backgroundColor: Color(0xFFE1306C),
    ),
    _ShareAppOption(
      label: 'Chat',
      icon: Icons.mark_chat_unread_outlined,
      backgroundColor: Colors.white,
      iconColor: Color(0xFFEA4335),
    ),
    _ShareAppOption(
      label: 'Gmail',
      icon: Icons.mail_outline,
      backgroundColor: Colors.white,
      iconColor: Color(0xFFEA4335),
    ),
    _ShareAppOption(
      label: 'WhatsApp',
      icon: Icons.chat_bubble_outline,
      backgroundColor: Color(0xFF25D366),
    ),
    _ShareAppOption(
      label: 'Cetak',
      icon: Icons.print_outlined,
      backgroundColor: Color(0xFF2196F3),
    ),
    _ShareAppOption(
      label: 'Bluetooth',
      icon: Icons.bluetooth,
      backgroundColor: Color(0xFF1976D2),
    ),
    _ShareAppOption(
      label: 'Chrome',
      icon: Icons.public,
      backgroundColor: Colors.white,
      iconColor: Color(0xFF1A73E8),
    ),
    _ShareAppOption(
      label: 'Simpan ke\nPengelola File',
      icon: Icons.folder_open,
      backgroundColor: Color(0xFFFFB300),
    ),
    _ShareAppOption(
      label: 'Pesan',
      icon: Icons.forum_outlined,
      backgroundColor: Colors.white,
      iconColor: Color(0xFF00897B),
    ),
    _ShareAppOption(
      label: 'Add to Chat',
      icon: Icons.auto_awesome,
      backgroundColor: Colors.white,
      iconColor: Color(0xFF4285F4),
    ),
    _ShareAppOption(
      label: 'Download',
      icon: Icons.download_outlined,
      backgroundColor: Colors.white,
      iconColor: Color(0xFF1E88E5),
    ),
    _ShareAppOption(
      label: 'Quick Share',
      icon: Icons.sync_alt,
      backgroundColor: Color(0xFF1E88E5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final String profileUrl =
        'https://strava.app.link/athlete/${athleteName.toLowerCase().replaceAll(' ', '_')}';

    return Container(
      decoration: const BoxDecoration(
        color: Styles.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 22.0,
        bottom: 12.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bagikan melalui',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Styles.tabActive,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 420,
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 0.95,
              children: _shareOptions.map<Widget>((_ShareAppOption item) {
                return GestureDetector(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: profileUrl));
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    if (item.label == 'Salin Tautan') {
                      onAppSelected(
                        'Tautan profil berhasil disalin: $profileUrl',
                      );
                    } else {
                      final String cleanLabel =
                          item.label.replaceAll('\n', ' ');
                      onAppSelected(
                        'Membagikan profil $athleteName ke $cleanLabel (Tautan disalin)',
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: item.backgroundColor,
                          borderRadius:
                              BorderRadius.circular(item.label == 'Salin Tautan'
                                  ? 28.0
                                  : 14.0),
                        ),
                        child: Icon(
                          item.icon,
                          color: item.iconColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Styles.tabActive,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}