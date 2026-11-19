import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:provider/provider.dart';
import '../models/gear_bag.dart';
import '../models/gear_catalog.dart';

class GearCatalogView extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onOpenBag;

  const GearCatalogView({
    super.key,
    required this.onBack,
    required this.onOpenBag,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _GearSliverAppBar(
          onBack: onBack,
          onOpenBag: onOpenBag,
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Pilih sepatu lari, sepeda, dan perangkat GPS yang Anda gunakan:',
              style: TextStyle(
                fontSize: 13,
                color: Styles.tabInactive,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _GearListItem(index),
            childCount: GearCatalogModel.itemNames.length,
          ),
        ),
      ],
    );
  }
}

class _GearSliverAppBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onOpenBag;

  const _GearSliverAppBar({
    required this.onBack,
    required this.onOpenBag,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Styles.surface,
      floating: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Styles.tabActive),
        onPressed: onBack,
      ),
      title: const Text(
        'Perlengkapan Atlet',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Styles.tabActive,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Consumer<GearBagModel>(
            builder: (context, bag, child) {
              return IconButton(
                onPressed: onOpenBag,
                icon: Badge(
                  isLabelVisible: bag.items.isNotEmpty,
                  backgroundColor: Styles.accent,
                  label: Text(
                    '${bag.items.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Styles.tabActive,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AddGearButton extends StatelessWidget {
  final GearItem item;

  const _AddGearButton({required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isInBag = context.select<GearBagModel, bool>(
      (bag) => bag.items.contains(item),
    );

    return TextButton(
      onPressed: isInBag
          ? null
          : () {
              final bag = context.read<GearBagModel>();
              bag.add(item);
            },
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.pressed)) {
            return Styles.accent;
          }
          return null;
        }),
      ),
      child: isInBag
          ? const Icon(
              Icons.check,
              color: Styles.active,
              semanticLabel: 'ADDED',
            )
          : const Text(
              'PAKAI',
              style: TextStyle(
                color: Styles.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}

class _GearListItem extends StatelessWidget {
  final int index;

  const _GearListItem(this.index);

  @override
  Widget build(BuildContext context) {
    final item = context.select<GearCatalogModel, GearItem>(
      (catalog) => catalog.getByPosition(index),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        color: Styles.surface,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: LimitedBox(
          maxHeight: 48,
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.directions_run,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Styles.tabActive,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _AddGearButton(item: item),
            ],
          ),
        ),
      ),
    );
  }
}