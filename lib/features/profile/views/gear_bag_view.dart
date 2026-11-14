import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:provider/provider.dart';
import '../models/gear_bag.dart';

class GearBagView extends StatelessWidget {
  final VoidCallback onBack;

  const GearBagView({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: onBack,
                child: const Icon(
                  Icons.arrow_back,
                  color: Styles.tabActive,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Tas Perlengkapan Aktif',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Styles.tabActive,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Styles.background,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _GearBagList(),
                  ),
                ),
                const Divider(height: 4, color: Styles.inactive),
                _GearBagTotal(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GearBagList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bag = context.watch<GearBagModel>();

    if (bag.items.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada perlengkapan yang dipilih.\nSilakan tambahkan dari katalog Perlengkapan.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Styles.tabInactive,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: bag.items.length,
      itemBuilder: (context, index) => Card(
        color: Styles.surface,
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: const Icon(Icons.check_circle, color: Styles.active),
          trailing: IconButton(
            icon: const Icon(
              Icons.remove_circle_outline,
              color: Styles.accent,
            ),
            onPressed: () {
              bag.remove(bag.items[index]);
            },
          ),
          title: Text(
            bag.items[index].name,
            style: const TextStyle(
              fontSize: 15,
              color: Styles.tabActive,
            ),
          ),
        ),
      ),
    );
  }
}

class _GearBagTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.surface,
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Target Jarak Gear',
                  style: TextStyle(
                    fontSize: 12,
                    color: Styles.tabInactive,
                  ),
                ),
                Consumer<GearBagModel>(
                  builder: (context, bag, child) => Text(
                    '${bag.totalPrice}0 km',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Styles.tabActive,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Styles.accent,
                    content: Text(
                      'Perlengkapan utama berhasil disinkronkan ke profil latihan!',
                      style: TextStyle(color: Styles.tabActive),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Styles.accent,
                foregroundColor: Styles.tabActive,
              ),
              child: const Text('SIMPAN GEAR'),
            ),
          ],
        ),
      ),
    );
  }
}