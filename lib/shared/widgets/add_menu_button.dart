import 'package:flutter/material.dart';

enum AddAction { post, photo, manualActivity }

class AddMenuButton extends StatelessWidget {
  final ValueChanged<AddAction> onSelected;

  const AddMenuButton({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AddAction>(
      icon: const Icon(Icons.add),
      color: Colors.grey.shade800,
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
        Icon(icon, color: Colors.white),
        const SizedBox(width: 16),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}