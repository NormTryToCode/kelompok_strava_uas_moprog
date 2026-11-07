import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/club_logo_placeholder.dart';

class ClubDetailHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSettings;

  const ClubDetailHeader({
    super.key,
    required this.onBack,
    required this.onSettings,
  });

  static const _bannerHeight = 150.0;
  static const _logoSize = 88.0;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Padding(
      padding: const EdgeInsets.only(bottom: _logoSize / 2),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: _bannerHeight + top,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF30333A), Color(0xFF101114)],
              ),
            ),
          ),
          Positioned(
            top: top + 8,
            left: 12,
            child: _CircleButton(icon: Icons.arrow_back, onTap: onBack),
          ),
          Positioned(
            top: top + 8,
            right: 12,
            child: _CircleButton(icon: Icons.settings_outlined, onTap: onSettings),
          ),
          const Positioned(
            left: 20,
            bottom: -_logoSize / 2,
            child: ClubLogoPlaceholder(size: _logoSize),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withAlpha(150),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}
