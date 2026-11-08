import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/search_field.dart';

class ClubsTab extends StatelessWidget {
  const ClubsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(hintText: 'Find clubs...'),
        _FilterRow(),
        Expanded(child: SizedBox.shrink()),
      ],
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 12,
        children: [
          _FilterChip(icon: Icons.location_on_outlined, label: 'Location'),
          _FilterChip(label: 'Sport type'),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final IconData? icon;
  final String label;

  const _FilterChip({this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final iconData = icon;
    return OutlinedButton.icon(
      onPressed: () {},
      icon: iconData == null ? const SizedBox.shrink() : Icon(iconData, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Styles.tabActive,
        shape: const StadiumBorder(),
        side: const BorderSide(color: Colors.white54),
      ),
    );
  }
}