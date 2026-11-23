import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class HorizontalCarousel<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final double height;
  final double viewportFraction;

  const HorizontalCarousel({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.height = 240,
    this.viewportFraction = 0.75,
  });

  factory HorizontalCarousel.cards({
    Key? key,
    required List<T> items,
    required Widget Function(BuildContext context, T item) cardBuilder,
    double height = 240,
    double viewportFraction = 0.75,
    bool bordered = false,
  }) {
    return HorizontalCarousel<T>(
      key: key,
      items: items,
      height: height,
      viewportFraction: viewportFraction,
      itemBuilder: (context, item) {
        final content = cardBuilder(context, item);
        return bordered
            ? CarouselCard.bordered(child: content)
            : CarouselCard(child: content);
      },
    );
  }

  factory HorizontalCarousel.banner({
    Key? key,
    required List<T> items,
    required Widget Function(BuildContext context, T item) itemBuilder,
    double height = 180,
  }) {
    return HorizontalCarousel<T>(
      key: key,
      items: items,
      itemBuilder: itemBuilder,
      height: height,
      viewportFraction: 0.92,
    );
  }

  @override
  State<HorizontalCarousel<T>> createState() => _HorizontalCarouselState<T>();
}

class _HorizontalCarouselState<T> extends State<HorizontalCarousel<T>> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: widget.viewportFraction);
  }

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
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.items.length,
            itemBuilder: (context, i) =>
                widget.itemBuilder(context, widget.items[i]),
          ),
          if (widget.items.length > 1) ...[
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
        ],
      ),
    );
  }
}

class CarouselCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final BoxBorder? border;

  const CarouselCard({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.border,
  });

  factory CarouselCard.bordered({Key? key, required Widget child}) {
    return CarouselCard(
      key: key,
      color: Styles.surface,
      border: Border.all(color: Styles.cardBorder),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: border,
      ),
      child: child,
    );
  }
}
