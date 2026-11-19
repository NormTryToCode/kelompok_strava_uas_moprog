import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class BadgeWidget extends StatefulWidget {
  const BadgeWidget({super.key});

  @override
  State<BadgeWidget> createState() => _BadgeWidgetState();
}

class BadgeItem {
  final String title;
  final String image;

  const BadgeItem({required this.title, required this.image});
}

class _BadgeWidgetState extends State<BadgeWidget> {
  final _controller = PageController(viewportFraction: 0.75);
  final _badges = const [
    BadgeItem(title: 'Basic Runner', image: 'images/basic_runner.png'),
    BadgeItem(title: 'Rookie Runner', image: 'images/rookie_runner.png'),
    BadgeItem(title: 'Master Runner', image: 'images/master_runner.png'),
    BadgeItem(title: 'Grand Master Runner', image: 'images/grand_master_runner.png'),
    BadgeItem(title: 'Super Speed', image: 'images/super_speed.png'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _arrow(Alignment align, IconData icon, VoidCallback onTap) {
    return Align(
      alignment: align,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Styles.accent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SizedBox(
        height: 240,
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: _badges.length,
              itemBuilder: (context, i) {
                final badge = _badges[i];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        badge.title,
                        style: const TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                      Expanded(child: Image.asset(badge.image)),
                      SizedBox(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {},
                          child: const Text('Inspect'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            _arrow(Alignment.centerLeft, Icons.chevron_left, () {
              _controller.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }),
            _arrow(Alignment.centerRight, Icons.chevron_right, () {
              _controller.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }),
          ],
        ),
      ),
    );
  }
}
