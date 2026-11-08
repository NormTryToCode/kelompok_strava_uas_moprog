import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class BadgeWidget extends StatefulWidget {
  const BadgeWidget({super.key});

  @override
  State<BadgeWidget> createState() => _BadgeWidgetState();
}

class _BadgeWidgetState extends State<BadgeWidget> {
  final _controller = PageController(viewportFraction: 0.75);
  final _titles = ['LOW', 'MIDDLE', 'HIGH'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _arrow(Alignment align, IconData icon, VoidCallback onTap) {
    return Align(
      alignment: align,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 56,
          color: Colors.green.withOpacity(0.6),
          child: Icon(icon, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Styles.badge,
      child: SizedBox(
        height: 260,
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: _titles.length,
              itemBuilder: (context, i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      _titles[i],
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {},
                        child: const Text('SELECT'),
                      ),
                    ),
                  ],
                ),
              ),
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
