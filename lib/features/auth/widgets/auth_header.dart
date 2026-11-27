import 'package:flutter/material.dart';

/// Shared header for authentication cards displaying either an icon badge or
/// the brand logo alongside a title and subtitle.
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String logoAsset;
  final IconData? icon;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.logoAsset = 'asset/images/Logo.png',
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 36,
              color: Colors.white,
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: 120,
              height: 120,
              child: Image.asset(logoAsset),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
