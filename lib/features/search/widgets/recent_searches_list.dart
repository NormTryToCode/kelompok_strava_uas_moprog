import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class RecentSearchesList extends StatelessWidget {
  final List<String> items;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onRemove;
  final VoidCallback onClear;

  const RecentSearchesList({
    super.key,
    required this.items,
    required this.onSelect,
    required this.onRemove,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
          child: Row(
            children: [
              const Text(
                'RECENT SEARCHES',
                style: TextStyle(
                  color: Styles.primaryLight,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onClear,
                child: const Text(
                  'Clear all',
                  style: TextStyle(
                    color: Styles.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        for (final item in items)
          ListTile(
            onTap: () => onSelect(item),
            leading: const Icon(Icons.history, color: Colors.white70),
            title: Text(
              item,
              style: const TextStyle(color: Styles.primaryLight, fontSize: 17),
            ),
            trailing: IconButton(
              tooltip: 'Remove $item',
              icon: const Icon(Icons.close, color: Colors.white54),
              onPressed: () => onRemove(item),
            ),
          ),
      ],
    );
  }
}

