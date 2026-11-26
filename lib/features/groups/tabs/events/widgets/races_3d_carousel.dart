import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/race_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/widgets/race_showcase_card.dart';

class Races3DCarousel extends StatefulWidget {
  final List<Race> races;
  final ValueChanged<Race> onRaceTap;

  const Races3DCarousel({
    super.key,
    required this.races,
    required this.onRaceTap,
  });

  @override
  State<Races3DCarousel> createState() => _Races3DCarouselState();
}

class _Races3DCarouselState extends State<Races3DCarousel> {
  late final PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.78)
      ..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_pageController.hasClients) return;
    final page = _pageController.page;
    if (page != null && page != _currentPage) {
      setState(() => _currentPage = page);
    }
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _handleCardTap(int index) {
    final activeIndex = _currentPage.round();
    if (index != activeIndex) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    widget.onRaceTap(widget.races[index]);
  }

  @override
  Widget build(BuildContext context) {
    final races = widget.races;
    if (races.isEmpty) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth * 0.76).clamp(260.0, 320.0);

    final orderedIndices = List<int>.generate(races.length, (i) => i)
      ..sort((a, b) {
        final distA = (a - _currentPage).abs();
        final distB = (b - _currentPage).abs();
        return distB.compareTo(distA);
      });

    final activeDot = _currentPage.round().clamp(0, races.length - 1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 312,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Layer visual 3D (foreground overlapping)
              IgnorePointer(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    for (final index in orderedIndices)
                      if ((index - _currentPage).abs() <= 2.2)
                        _build3DCard(
                          race: races[index],
                          index: index,
                          cardWidth: cardWidth,
                        ),
                  ],
                ),
              ),
              // Layer gestur swipe & tap dengan physics PageView
              PageView.builder(
                controller: _pageController,
                itemCount: races.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _handleCardTap(index),
                    child: const SizedBox.expand(),
                  );
                },
              ),
            ],
          ),
        ),
        if (races.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < races.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.symmetric(horizontal: 3.5),
                  width: i == activeDot ? 20 : 6.5,
                  height: 6.5,
                  decoration: BoxDecoration(
                    color: i == activeDot
                        ? Styles.primaryLight
                        : Styles.borderStrong,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: i == activeDot
                        ? Styles.glow(intensity: 0.4, blur: 8)
                        : null,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _build3DCard({
    required Race race,
    required int index,
    required double cardWidth,
  }) {
    final delta = index - _currentPage;
    final absDelta = delta.abs();

    final scale = (1.0 - absDelta * 0.13).clamp(0.76, 1.0);
    final opacity = (1.0 - absDelta * 0.36).clamp(0.42, 1.0);
    final translateX = delta * (cardWidth * 0.56);
    final translateY = absDelta * 10.0;
    final rotateY = (-delta * 0.22).clamp(-0.35, 0.35);

    final matrix = Matrix4.identity()
      ..setEntry(3, 2, 0.0014)
      ..translateByDouble(translateX, translateY, 0.0, 1.0)
      ..rotateY(rotateY)
      ..scaleByDouble(scale, scale, 1.0, 1.0);

    return Transform(
      alignment: Alignment.center,
      transform: matrix,
      child: Opacity(
        opacity: opacity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radii.card),
            boxShadow: absDelta < 0.35
                ? [
                    BoxShadow(
                      color: Styles.canvas.withValues(alpha: 0.85),
                      blurRadius: 24,
                      spreadRadius: 2,
                      offset: const Offset(0, 10),
                    ),
                    ...Styles.glow(
                      color: Styles.primary,
                      intensity: math.max(0.0, (0.35 - absDelta) * 0.9),
                      blur: 22,
                    ),
                  ]
                : null,
          ),
          child: SizedBox(
            width: cardWidth,
            height: 292,
            child: RaceShowcaseCard(
              race: race,
              onTap: () {},
            ),
          ),
        ),
      ),
    );
  }
}