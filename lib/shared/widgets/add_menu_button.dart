import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

enum AddAction { post, photo, manualActivity, activityHistory }

class AddMenuButton extends StatelessWidget {
  final ValueChanged<AddAction> onSelected;

  const AddMenuButton({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AddAction>(
      icon: const Icon(Icons.add, color: Styles.textPrimary),
      color: Styles.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Styles.border),
      ),
      onSelected: onSelected,
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: AddAction.post,
          child: _MenuRow(icon: Icons.article_outlined, label: 'Post'),
        ),
        PopupMenuItem(
          value: AddAction.photo,
          child: _MenuRow(icon: Icons.image_outlined, label: 'Photo'),
        ),
        PopupMenuItem(
          value: AddAction.manualActivity,
          child: _MenuRow(icon: Icons.show_chart, label: 'Manual Activity'),
        ),
        PopupMenuItem(
          value: AddAction.activityHistory,
          child: _MenuRow(icon: Icons.history, label: 'My Activities'),
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MenuRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Styles.primaryLight, size: 20),
        const SizedBox(width: 14),
        Text(
          label,
          style: const TextStyle(
            color: Styles.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}